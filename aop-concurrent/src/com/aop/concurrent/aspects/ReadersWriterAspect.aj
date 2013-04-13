package com.aop.concurrent.aspects;

import java.util.HashMap;
import java.util.Map;

import com.aop.concurrent.annotations.Reader;
import com.aop.concurrent.annotations.Writer;

/**
 * Aspect handling readers-writer problem.
 *
 * @author minowak
 */
public aspect ReadersWriterAspect {
	/**
	 * Maps id to reader count.
	 */
	private static Map<String, Long> readersCount = new HashMap<String, Long>();
	private static Long masterReadersCount = new Long(0);

	/**
	 * Maps id to writing lock.
	 */
	private static Map<String, Boolean> writingLocks = new HashMap<String, Boolean>();
	private static Boolean masterWritingLock = new Boolean(false);

	/**
	 * Maps id to lock.
	 */
	private static Map<String, Object> locks = new HashMap<String, Object>();
	private static Object masterLock = new Object();

	/**
	 * Pointcut: reader.
	 *
	 * @param reader
	 * 			reader annotation
	 */
	pointcut readerPoint(Reader reader) : execution(@Reader * *.*(..)) && @annotation(reader);

	/**
	 * Pointcut: writer.
	 *
	 * @param writer
	 * 			writer annotation
	 */
	pointcut writerPoint(Writer writer) : execution(@Writer * *.*(..)) && @annotation(writer);

	/**
	 * Advice: reader.
	 *
	 * @param reader
	 * 			reader annotation
	 * @return method call result
	 */
	Object around(Reader reader) : readerPoint(reader) {
		Long currentReadersCount = null;
		Boolean currentWritingLock = null;
		Object currentLock = null;

		if(reader.library().isEmpty()) {
			currentReadersCount = masterReadersCount;
			currentWritingLock = masterWritingLock;
			currentLock = masterLock;
		} else {
			// Readers count
			if(readersCount.get(reader.library()) == null) {
				currentReadersCount = new Long(0);
				readersCount.put(reader.library(), currentReadersCount);
			} else {
				currentReadersCount = readersCount.get(reader.library());
			}
			// Writer lock
			if(writingLocks.get(reader.library()) == null) {
				currentWritingLock = new Boolean(false);
				writingLocks.put(reader.library(), currentWritingLock);
			} else {
				currentWritingLock = writingLocks.get(reader.library());
			}

			// Locks
			if(locks.get(reader.library()) == null) {
				currentLock = new Object();
				locks.put(reader.library(), currentLock);
			} else {
				currentLock = locks.get(reader.library());
			}
		}

		// Check if someone is writing
		while(currentWritingLock) {
			try {
				currentLock.wait();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		// Start reading
		currentReadersCount++;
		Object ret = proceed(reader);
		if(--currentReadersCount == 0) {
			currentLock.notifyAll();
		}

		return ret;
	}

	/**
	 * Advice: writer.
	 *
	 * @param reader
	 * 			reader annotation
	 * @return method call result
	 */
	Object around(Writer writer) : writerPoint(writer) {
		Long currentReadersCount = null;
		Boolean currentWritingLock = null;
		Object currentLock = null;

		if(writer.library().isEmpty()) {
			currentReadersCount = masterReadersCount;
			currentWritingLock = masterWritingLock;
		} else {
			// Readers count
			if(readersCount.get(writer.library()) == null) {
				currentReadersCount = new Long(0);
				readersCount.put(writer.library(), currentReadersCount);
			} else {
				currentReadersCount = readersCount.get(writer.library());
			}

			// Writer lock
			if(writingLocks.get(writer.library()) == null) {
				currentWritingLock = new Boolean(false);
				writingLocks.put(writer.library(), currentWritingLock);
			} else {
				currentWritingLock = writingLocks.get(writer.library());
			}

			// Locks
			if(locks.get(writer.library()) == null) {
				currentLock = new Object();
				locks.put(writer.library(), currentLock);
			} else {
				currentLock = locks.get(writer.library());
			}
		}

		// Wait for readers to stop reading
		while(currentReadersCount > 0) {
			try {
				currentLock.wait();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		// Write
		currentWritingLock = true;
		Object ret = proceed(writer);
		currentWritingLock = false;
		currentLock.notifyAll();

		return ret;
	}
}

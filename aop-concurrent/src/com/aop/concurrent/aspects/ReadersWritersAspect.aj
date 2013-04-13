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
public aspect ReadersWritersAspect {
	/**
	 * Maps id to reader count.
	 */
	private static Map<String, Long> readersCount = new HashMap<String, Long>();
	private static Long masterReadersCount = new Long(0);

	/**
	 * Maps id to writing lock.
	 */
	private static Map<String, Object> writingLocks = new HashMap<String, Object>();
	private static Object masterWritingLock = new Object();

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
		Object currentWritingLock = null;
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
				currentWritingLock = new Object();
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

		// Start reading
		Object ret = null;
		try {
			currentReadersCount++;
			if(currentReadersCount == 1) {
				System.out.println("[READER] Waiting on writing lock: " + currentWritingLock.hashCode());
				synchronized(currentWritingLock) {	}
			}
			synchronized(currentLock) {
				currentLock.notify();
			}
			ret = proceed(reader);

			synchronized(currentLock) {
				if(--currentReadersCount == 0) {
					System.out.println("[READER] Signal send to writing lock");
					synchronized(currentWritingLock) {
						currentWritingLock.notify();
					}
				}
				currentLock.notify();
			}
		} catch(InterruptedException e) {
			e.printStackTrace();
		}

		System.out.println("[READER] Done");

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
		Object currentWritingLock = null;
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
				currentWritingLock = new Object();
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

		// Write
		Object ret = null;
		synchronized(currentWritingLock) {
			try {
				System.out.println("[WRITER] Staring to write: " + writer.library());
				ret = proceed(writer);
				System.out.println("[WRITER] Done writing: " + writer.library());
				System.out.println("[WRITER] Notyfying: " + currentWritingLock.hashCode());
				currentWritingLock.notify();
			} catch(InterruptedException e) {
				e.printStackTrace();
			}
		}

		return ret;
	}
}

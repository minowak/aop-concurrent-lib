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
		Long currentReadersCount = getCurrentReadersCount(reader.library());
		Object currentWritingLock = getCurrentWritingLock(reader.library());
		Object currentLock = getCurrentLock(reader.library());

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
		Object currentWritingLock = getCurrentWritingLock(writer.library());

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

	/**
	 * Return current readers count.
	 *
	 * @param library
	 * 			library name
	 * @return current readers count
	 */
	private Long getCurrentReadersCount(String library) {
		Long currentReadersCount = null;
		if(library.isEmpty()) {
			currentReadersCount = masterReadersCount;
		} else
		if(readersCount.get(library) == null) {
			currentReadersCount = new Long(0);
			readersCount.put(library, currentReadersCount);
		} else {
			currentReadersCount = readersCount.get(library);
		}

		return currentReadersCount;
	}

	/**
	 * Returns current writing lock.
	 *
	 * @param library
	 * 			library name
	 * @return current writing lock
	 */
	private Object getCurrentWritingLock(String library) {
		Object currentWritingLock = null;
		if(library.isEmpty()) {
			currentWritingLock = masterWritingLock;
		} else
		if(writingLocks.get(library) == null) {
			currentWritingLock = new Object();
			writingLocks.put(library, currentWritingLock);
		} else {
			currentWritingLock = writingLocks.get(library);
		}
		return currentWritingLock;
	}

	/**
	 * Returns current lock.
	 *
	 * @param library
	 * 			library name
	 * @return current lock
	 */
	private Object getCurrentLock(String library) {
		Object currentLock = null;
		if(library.isEmpty()) {
			currentLock = masterLock;
		} else
		if(locks.get(library) == null) {
			currentLock = new Object();
			locks.put(library, currentLock);
		} else {
			currentLock = locks.get(library);
		}

		return currentLock;
	}
}

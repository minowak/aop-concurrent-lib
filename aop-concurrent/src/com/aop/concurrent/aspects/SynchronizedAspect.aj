package com.aop.concurrent.aspects;

import java.util.HashMap;
import java.util.Map;

import com.aop.concurrent.annotations.Synchronized;

/**
 * Aspect for handling @Synchronized annotations.
 *
 * @author minowak
 */
public aspect SynchronizedAspect {
	private static Map<String, Object> locks = new HashMap<String, Object>();
	private static Object masterLock = new Object();

	/**
	 * Pointcut: methods with @Synchronized annotation.
	 */
	pointcut syncPoint(Synchronized sync) : execution(@Synchronized * *.*(..)) && @annotation(sync);

	/**
	 * Advice: synchronizing method calls
	 *
	 * @return method call result
	 */
	Object around(Synchronized sync): syncPoint(sync) {
		Object currentLock = null;
		if(sync.id().isEmpty()) {
			currentLock = masterLock;
			System.out.println("Getting master lock");
		} else
		if(locks.get(sync.id()) == null) {
			System.out.println("Getting new lock for: " + sync.id());
			currentLock = new Object();
			locks.put(sync.id(), currentLock);
		} else {
			System.out.println("Getting lock for: " + sync.id());
			currentLock = locks.get(sync.id());
		}
		synchronized(currentLock) {
			return proceed(sync);
		}
	}
}

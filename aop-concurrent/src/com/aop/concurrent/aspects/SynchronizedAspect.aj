package com.aop.concurrent.aspects;

import java.util.HashMap;
import java.util.Map;

import com.aop.concurrent.annotations.Synchronized;

/**
 * Aspect for handling @Synchronized annotations.
 *
 * @author nowak
 */
public aspect SynchronizedAspect {
	private static Map<String, Object> locks = new HashMap<String, Object>();

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
		if(locks.get(sync.id()) == null) {
			locks.put(sync.id(), new Object());
		}
		synchronized(locks.get(sync.id())) {
			return proceed(sync);
		}
	}
}

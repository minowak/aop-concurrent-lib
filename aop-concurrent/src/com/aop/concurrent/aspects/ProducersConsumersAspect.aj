package com.aop.concurrent.aspects;

import java.util.concurrent.Semaphore;

import com.aop.concurrent.annotations.Consumer;
import com.aop.concurrent.annotations.Producer;
//import com.aop.concurrent.utils.BufferHelper;

/**
 * Aspect for producers-consumers problem
 * 
 * @author adam
 *
 */
public aspect ProducersConsumersAspect {

	private int itemsCount = 0;
	private Object full = new Object();
	private Object empty = new Object();
	
	private Semaphore fillSemaphore ;
	private Semaphore emptySemaphore ;
	private Semaphore mutexJ = new Semaphore(1);
	private Semaphore mutexK = new Semaphore(1);
	private Semaphore mutex = new Semaphore(1);
	
	/**
	 * Producer pointcut
	 * @param producer
	 */
	pointcut producerPoint(Producer producer) : execution(@Producer * *.*(..)) && @annotation(producer);	

	/**
	 * Consumer pointcut
	 * @param producer
	 */
	pointcut consumerPoint(Consumer consumer) : execution(@Consumer * *.*(..)) && @annotation(consumer);	



	Object around(Producer producer) : producerPoint(producer) {
//		System.out.println("producer aspect");
		Object ret = null;
		try {
			mutex.acquire();
			if (fillSemaphore == null) {
				fillSemaphore = new Semaphore(0);
			}
			if (emptySemaphore == null) {
				emptySemaphore = new Semaphore(producer.size());
			}
			mutex.release();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		try {
			emptySemaphore.acquire();
				mutexJ.acquire();
					ret = proceed(producer);
				mutexJ.release();
			fillSemaphore.release();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		
		return ret;
	}

	Object around(Consumer consumer) : consumerPoint(consumer) {
//		System.out.println("consumer aspect");
		Object ret = null;
		try {
			mutex.acquire();
			if (fillSemaphore == null) {
				fillSemaphore = new Semaphore(0);
			}
			if (emptySemaphore == null) {
				emptySemaphore = new Semaphore(consumer.size());
			}
			mutex.release();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		try {
			fillSemaphore.acquire();
				mutexK.acquire();
					ret = proceed(consumer);
				mutexK.release();
			emptySemaphore.release();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return ret;
	}


//	private Object getLock(String name) {
//		
//	}
}
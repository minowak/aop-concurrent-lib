package com.aop.concurrent.aspects;

import com.aop.concurrent.utils.ProdConsBuffer;


/**
 * Aspect for producers-consumers problem
 * 
 * @author adam
 *
 */
public aspect ProducersConsumersAspect {

	private int consumers = 0; // number of blocked consumers
	private int producers = 0; // number of blocked producers
	
	pointcut producePointcut(): call(void ProdConsBuffer.produce(int));
	pointcut consumerPointcut(): call(int ProdConsBuffer.consume() );
	
	
	before(): producePointcut() {
//		System.out.println("before(): producePointcut()");
//		System.out.println("ProdConsBuffer.count: " + ProdConsBuffer.count);
		synchronized (this) {
			while ( ProdConsBuffer.count >= ProdConsBuffer.SIZE ) {
				producers++;
				try {
					wait();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	after() returning: producePointcut() {
//		System.out.println("after() returning: producePointcut()");
//		System.out.println("ProdConsBuffer.count: " + ProdConsBuffer.count);
		synchronized (this) {
			if (consumers > 0) {
				consumers--;
				notify();
			}
		}
	}
	
	before(): consumerPointcut() {
//		System.out.println("before(): consumerPointcut()");
//		System.out.println("ProdConsBuffer.count: " + ProdConsBuffer.count);
		synchronized (this) {
			while ( ProdConsBuffer.count <= 0 ) {
				consumers++;
				try {
					wait();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	after() returning: consumerPointcut() {
//		System.out.println("after() returning: consumerPointcut()");
//		System.out.println("ProdConsBuffer.count: " + ProdConsBuffer.count);
		synchronized (this) {
			if (producers > 0) {
				producers--;
				notify();
			}
		}
	}
	
}

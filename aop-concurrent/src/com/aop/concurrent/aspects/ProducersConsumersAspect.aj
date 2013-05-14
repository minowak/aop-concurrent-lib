package com.aop.concurrent.aspects;

import java.util.HashMap;
import java.util.Map;

import com.aop.concurrent.annotations.Consumer;
import com.aop.concurrent.annotations.Producer;
import com.aop.concurrent.utils.BufferHelper;

/**
 * Aspect for producers-consumers problem
 * 
 * @author adam
 *
 */
public aspect ProducersConsumersAspect {

	Map<String, BufferHelper> buffers = new HashMap<String,BufferHelper>(); // map name-buffer
	Map<String, Integer> items = new HashMap<String,Integer>(); // how many items is in given buffer

	private int producers; // count of blocked producers
	private int consumers; // count of blocked consumers
	
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
		System.out.println("producer");
		Object ret = null;
		BufferHelper buffer = null;
		synchronized (buffers) {
			buffer = buffers.get(producer.buffer()); 
			if (buffer == null) {
				buffer = new BufferHelper(producer.size());
				buffers.put(producer.buffer(), buffer);
			}
		}
		
//		try {
//			buffer.getMainLock().lock();
//			while (!buffer.canProduce()) {
//				try {
//					buffer.getEmptyCondition().await();
//				} catch (InterruptedException e) {
//					e.printStackTrace();
//				}
//			}
//			ret = proceed(producer);
//			buffer.produce();
//			buffer.notifyConsumers();
//		} finally {
//			buffer.getMainLock().unlock();
//		}
		
		if (!buffer.canProduce()) {
			while (!buffer.canProduce()) {
				try {
					synchronized (buffer.getProducerLock()) {
						buffer.getProducerLock().wait();
					}
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}

		}
//		else {
			synchronized (buffer) {
				buffer.produce();
				ret = proceed(producer);
				synchronized (buffer.getConsumerLock()) {
					
					buffer.getConsumerLock().notify();
					}
//				buffer.getConsumerLock().notify();
			}
//		}
			System.out.println(buffer);

		return ret;
	}
	
	Object around(Consumer consumer) : consumerPoint(consumer) {
		System.out.println("consumer");
		Object ret = null;
		BufferHelper buffer = null;
		synchronized (buffers) {
			buffer = buffers.get(consumer.buffer()); 
			if (buffer == null) {
				buffer = new BufferHelper(consumer.size());
				buffers.put(consumer.buffer(), buffer);
			}
		}
		
//		try {
//			buffer.getMainLock().lock();
//			while (!buffer.canProduce()) {
//				try {
//					buffer.getFullCondition().await();
//				} catch (InterruptedException e) {
//					e.printStackTrace();
//				}
//			}
//			ret = proceed(consumer);
//			buffer.consume();
//			buffer.notifyProducers();
//		} finally {
//			buffer.getMainLock().unlock();
//		}
		
//		buffer.getMainLock().lock();
		if (!buffer.canConsume()) {
//		} else {
			while (!buffer.canConsume()) {
				try {
					synchronized (buffer.getConsumerLock()) {
						buffer.getConsumerLock().wait();
					}
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		}
		synchronized (buffer) {
			buffer.consume();
			ret = proceed(consumer);
			synchronized (buffer.getProducerLock()) {
				
			buffer.getProducerLock().notify();
			}
		}
		System.out.println(buffer);
		return ret;
	}
	

//	private Object getLock(String name) {
//		
//	}
}

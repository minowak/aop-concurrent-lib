package com.aop.concurrent.utils;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class BufferHelper {

	private int size;
	private int free;

	private Lock mainLock;
	private Object producerLock;
	private Object consumerLock;
	private Condition full;
	private Condition empty;
	
	public BufferHelper(int size) {
		consumerLock = new Object();
		producerLock = new Object();
		this.size = size;
		this.free = size;
		mainLock = new ReentrantLock();
		full = mainLock.newCondition();
		empty = mainLock.newCondition();
	}

	public void notifyConsumers() {
		if ( free == size - 1)
			full.signal();
	}
	
	public void notifyProducers() {
		if ( free == 1)
			empty.signal();
	}
	
	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

	public int getFree() {
		return free;
	}

	public void setFree(int free) {
		this.free = free;
	}
	
	public void produce() {
		free--;
	}
	
	public void consume() {
		free++;
	}
	
	public boolean canProduce() {
		return free > 0;
	}
	
	public boolean canConsume() {
		return free < size;
	}

	public Lock getMainLock() {
		return mainLock;
	}

	public Condition getFullCondition() {
		return full;
	}

	public Condition getEmptyCondition() {
		return empty;
	}

	public Object getProducerLock() {
		return producerLock;
	}

	public void setProducerLock(Lock producerLock) {
		this.producerLock = producerLock;
	}

	public Object getConsumerLock() {
		return consumerLock;
	}

	public void setConsumerLock(Lock consumerLock) {
		this.consumerLock = consumerLock;
	}

	
}

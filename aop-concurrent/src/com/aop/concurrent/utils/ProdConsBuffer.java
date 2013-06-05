package com.aop.concurrent.utils;

import com.aop.concurrent.annotations.Consumer;
import com.aop.concurrent.annotations.Producer;


public class ProdConsBuffer {

	public static int SIZE = 5;
	private int[] buffer = new int[SIZE];
	private int front = 0;
	private int rear = 0;
	
	public static int count = 0;
	
	public ProdConsBuffer() {
		front = 0;
		rear = 0;
		count = 0;
	}
	
	@Consumer(buffer="a", size=5)
	public int consume() {
		front = (front+1) % SIZE;
//		System.out.println("Consumed: " + buffer[front]);
		count--;
		System.out.println("consumed: " + buffer[front]);
		return buffer[front];
	}
	
	@Producer(buffer="a", size=5)	
	public void produce(int item) {
		rear = (rear+1) % SIZE;
		buffer[rear] = item;
		System.out.println("Produced: " + item);
		count++;
	}

	
}

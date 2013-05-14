package com.aop.concurrent.utils;


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
	
	public synchronized int consume() {
		front = (front+1) % SIZE;
		System.out.println("Consumed: " + buffer[front]);
		count--;
		return buffer[front];
	}
	
	public synchronized void produce(int item) {
		rear = (rear+1) % SIZE;
		buffer[rear] = item;
		System.out.println("Produced: " + item);
		count++;
	}

	
}

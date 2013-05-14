package com.aop.concurrent.test.synchronize;

public class ProducerConsumerBuffer {
	
	private static final int SIZE = 5;
	private static int[] buffer = new int[SIZE];
	private static int produceIndex = 0;
	private static int consumeIndex = 0;
	private static int free = SIZE;
	
	public static void produce(int item) {
		System.out.println("Buffer: want to add " + item);
		if (free > 0) {
			buffer[produceIndex++] = item;
			free--;
			produceIndex = produceIndex % SIZE;
			System.out.println("Buffer: added " + item);
		}
		
	}

	public static int consume() {

		if (free < SIZE) {
			free++;
			int result = buffer[consumeIndex];
			consumeIndex = consumeIndex-- % SIZE;
			System.out.println("Buffer: consumed " + result);
			return result;
		}
		
		return 0;
	}

	
}

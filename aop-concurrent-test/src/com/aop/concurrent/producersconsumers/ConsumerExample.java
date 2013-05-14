package com.aop.concurrent.producersconsumers;

import com.aop.concurrent.annotations.Consumer;
import com.aop.concurrent.annotations.Producer;
import com.aop.concurrent.test.synchronize.ProducerConsumerBuffer;

public class ConsumerExample extends Thread {

	private long sleepTime;
	private long loops;
	
	public ConsumerExample(long sleepTime, long loops) {
		this.sleepTime = sleepTime;
		this.loops = loops;
	}
	
	@Consumer(buffer="aaa", size=10)
	public void run() {
		try {
			for (int i=0; i<loops; i++) {
				int item = ProducerConsumerBuffer.consume();
				System.out.println("Consumer: consumeds " + item);
				Thread.sleep(sleepTime);
			}
		} catch(InterruptedException e) {
			e.printStackTrace();
		}
	}
	
}

package com.aop.concurrent.producersconsumers;

import java.util.Random;

import com.aop.concurrent.annotations.Producer;
import com.aop.concurrent.test.synchronize.ProducerConsumerBuffer;


public class ProducerExample extends Thread {

	private long sleepTime;
	private long loops;
	private Random random;
	
	public ProducerExample(long sleepTime, long loops) {
		this.sleepTime = sleepTime;
		this.loops = loops;
		random = new Random();
	}
	
	@Producer(buffer="aaa", size=10)
	public void run() {
		try {
			for (int i=0; i<loops; i++) {
				int item = random.nextInt();
				System.out.println("Producer: will add " + item);
				ProducerConsumerBuffer.produce(item);
				Thread.sleep(sleepTime);
			}
		} catch(InterruptedException e) {
			e.printStackTrace();
		}
	}
	
}

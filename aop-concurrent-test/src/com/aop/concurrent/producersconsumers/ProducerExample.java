package com.aop.concurrent.producersconsumers;

import java.util.Random;

import com.aop.concurrent.utils.ProdConsBuffer;


public class ProducerExample extends Thread {

	private long sleepTime;
	private long loops;
	private Random random;
	private ProdConsBuffer buff;
	
	public ProducerExample(long sleepTime, long loops, ProdConsBuffer buff) {
		this.sleepTime = sleepTime;
		this.loops = loops;
		this.buff = buff;
		random = new Random();
	}
	
	public void run() {
		try {
			for (int i=0; i<loops; i++) {
				int item = random.nextInt();
//				System.out.println("Producer: will add " + item);
				buff.produce(item);
				Thread.sleep(sleepTime);
			}
		} catch(InterruptedException e) {
			e.printStackTrace();
		}
	}
	
}

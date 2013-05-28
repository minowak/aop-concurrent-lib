package com.aop.concurrent.producersconsumers;

import com.aop.concurrent.utils.ProdConsBuffer;

public class ConsumerExample extends Thread {

	private long sleepTime;
	private long loops;
	private ProdConsBuffer buff;
	
	public ConsumerExample(long sleepTime, long loops, ProdConsBuffer buff) {
		this.sleepTime = sleepTime;
		this.loops = loops;
		this.buff = buff;
	}
	
	public void run() {
		try {
			for (int i=0; i<loops; i++) {
				int item = buff.consume();
//				System.out.println("Consumer: " + item);
				Thread.sleep(sleepTime);
			}
		} catch(InterruptedException e) {
			e.printStackTrace();
		}
	}
	
}

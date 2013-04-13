package com.aop.concurrent.test.synchronize;

import com.aop.concurrent.annotations.Synchronized;

public class ExampleSynchronizedBetween2 extends Thread {
	private long time;
	private String text;

	public ExampleSynchronizedBetween2(String text, long time) {
		this.time = time;
		this.text = text;
	}

	@Synchronized(id = "id2")
	public void run() {
		try {
			for(int i = 0 ; i < text.length() ; i++) {
				Buffer.add(text.charAt(i));
				Thread.sleep(time);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}

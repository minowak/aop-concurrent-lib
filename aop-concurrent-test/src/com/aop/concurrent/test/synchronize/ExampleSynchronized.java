package com.aop.concurrent.test.synchronize;

import com.aop.concurrent.annotations.Synchronized;

public class ExampleSynchronized extends Thread {
	private String text;
	private static String currentText = new String("");
	private long time;

	public ExampleSynchronized(String text, long time) {
		this.text = text;
		this.time = time;
	}

	@Synchronized
	public void run() {
		try {
			for(int i = 0 ; i < text.length() ; i++) {
				currentText += text.charAt(i);
				Thread.sleep(time);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public String getCurrentText() {
		return currentText;
	}
}

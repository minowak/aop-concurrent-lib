package com.aop.concurrent.readerswriter;

import com.aop.concurrent.annotations.Reader;
import com.aop.concurrent.test.synchronize.Buffer;

public class ReaderExample extends Thread {
	private static final long COUNT = 1;

	private long time;

	private String result;

	private boolean success = true;

	public ReaderExample(long time) {
		this.time = time;
		result = new String();
	}

	@Reader(library = "lib1")
	public void run() {
		readFromBuffer();
	}

	private void readFromBuffer() {
		long l = COUNT;
		while(l-- > 0) {
			result = Buffer.get();
			System.out.println("read: " + result);
			if(!result.equals("qwertyuiop")) {
				success = false;
			}
			try {
				Thread.sleep(time);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

	public boolean getResult() {
		return success;
	}
}

package com.aop.concurrent.readerswriter;

import com.aop.concurrent.annotations.Reader;
import com.aop.concurrent.test.synchronize.Buffer;

public class ReaderExample2 extends Thread {
	private static final long COUNT = 1;

	private long time;

	private String result;

	private boolean success = true;

	public ReaderExample2(long time) {
		this.time = time;
		result = new String();
	}

//	@Reader(library = "lib1")
	public void run() {
		long l = COUNT;
		while(l-- > 0) {
			result = read();
			System.out.println("read2: " + result);
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
	
	@Reader(library = "lib1")
	public String read() {
		return Buffer.get();
	}
	public boolean getResult() {
		return success;
	}
}

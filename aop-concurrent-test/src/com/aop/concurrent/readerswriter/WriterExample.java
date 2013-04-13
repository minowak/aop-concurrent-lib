package com.aop.concurrent.readerswriter;

import com.aop.concurrent.annotations.Synchronized;
import com.aop.concurrent.annotations.Writer;
import com.aop.concurrent.test.synchronize.Buffer;

public class WriterExample extends Thread {
	private long time;

	private static final String TEXT = "qwertyuiop";

	private static final long COUNT = 5;

	public WriterExample(long time) {
		this.time = time;
	}

	@Writer(library = "lib1")
	public void run() {
		try {
			Buffer.clean();
			for(int i = 0 ; i < TEXT.length() ; i++) {
				Buffer.add(TEXT.charAt(i));
				Thread.sleep(time);
			}
			Thread.sleep(time * 5);
		} catch(InterruptedException e) {
			e.printStackTrace();
		}
	}
}

package com.aop.concurrent.test;

import static org.junit.Assert.*;

import org.junit.Test;

import com.aop.concurrent.test.synchronize.ExampleSynchronized;

public class SynchronizedTest {

	private final static String EXAMPLE_TEXT1 = "QWERTYUIOP";

	private final static String EXAMPLE_TEXT2 = "ASDFGHJKL";

	private final static long TIME1 = 500;

	private final static long TIME2 = 5;

	/**
	 * Tests @Synchronized in one class.
	 */
	@Test
	public void testSynchronizedInOneClass() throws InterruptedException {
		// given
		ExampleSynchronized es1 = new ExampleSynchronized(EXAMPLE_TEXT1, TIME1);
		ExampleSynchronized es2 = new ExampleSynchronized(EXAMPLE_TEXT2, TIME2);

		// when
		es1.start();
		es2.start();
		es1.join();
		es2.join();

		// then
		assertEquals(es1.getCurrentText(), String.format("%s%s", EXAMPLE_TEXT1, EXAMPLE_TEXT2));
	}

}

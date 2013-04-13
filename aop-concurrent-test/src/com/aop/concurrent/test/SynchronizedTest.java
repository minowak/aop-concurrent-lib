package com.aop.concurrent.test;

import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

import com.aop.concurrent.test.synchronize.Buffer;
import com.aop.concurrent.test.synchronize.ExampleSynchronized;
import com.aop.concurrent.test.synchronize.ExampleSynchronizedBetween1;
import com.aop.concurrent.test.synchronize.ExampleSynchronizedBetween2;

/**
 * Tests for @Synchronized. We test only success cases as we can't provide
 * 100% sure test cases for failures.
 *
 * @author minowak
 */
public class SynchronizedTest {

	private final static String EXAMPLE_TEXT1 = "QWERTYUIOP";

	private final static String EXAMPLE_TEXT2 = "ASDFGHJKL";

	private final static long TIME1 = 50;

	private final static long TIME2 = 5;

	/**
	 * Called before each test case. Cleans buffer.
	 */
	@Before
	public void init() {
		Buffer.clean();
	}

	/**
	 * Tests @Synchronized in one class.
	 *
	 * @throws InterruptedException
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

	/**
	 * Tests @Synchronized between different classes.
	 *
	 * @throws InterruptedException
	 */
	@Test
	public void testSynchronizedBetweenClasses() throws InterruptedException {
		// given
		ExampleSynchronizedBetween1 es1 = new ExampleSynchronizedBetween1(EXAMPLE_TEXT1, TIME1);
		ExampleSynchronizedBetween2 es2 = new ExampleSynchronizedBetween2(EXAMPLE_TEXT2, TIME2);

		// when
		es1.start();
		es2.start();
		es1.join();
		es2.join();

		// then
		assertEquals(Buffer.get(), String.format("%s%s", EXAMPLE_TEXT1, EXAMPLE_TEXT2));
	}

}

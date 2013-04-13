package com.aop.concurrent.test.synchronize;

public class Buffer {
	private static String content = new String();

	public static void add(char str) {
		content += str;
	}

	public static String get() {
		return content;
	}

	public static void clean() {
		content = "";
	}
}

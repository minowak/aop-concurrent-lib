package com.aop.concurrent.aspects;

import com.aop.concurrent.annotations.Reader;
import com.aop.concurrent.annotations.Writer;

/**
 * Aspect handling readers-writer problem.
 *
 * @author minowak
 */
public aspect ReadersWriterAspect {
	/**
	 * Pointcut: reader.
	 *
	 * @param reader
	 * 			reader annotation
	 */
	pointcut readerPoint(Reader reader) : execution(@Reader * *.*(..)) && @annotation(reader);

	/**
	 * Pointcut: writer.
	 *
	 * @param writer
	 * 			writer annotation
	 */
	pointcut writerPoint(Writer writer) : execution(@Writer * *.*(..)) && @annotation(writer);

	/**
	 * Advice: reader.
	 *
	 * @param reader
	 * 			reader annotation
	 * @return method call result
	 */
	Object around(Reader reader) : readerPoint(reader) {
		return proceed(reader);
	}

	/**
	 * Advice: writer.
	 *
	 * @param reader
	 * 			reader annotation
	 * @return method call result
	 */
	Object around(Writer writer) : writerPoint(writer) {
		return proceed(writer);
	}
}

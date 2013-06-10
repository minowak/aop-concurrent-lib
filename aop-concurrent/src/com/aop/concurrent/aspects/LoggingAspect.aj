package com.aop.concurrent.aspects;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import com.aop.concurrent.annotations.Consumer;
import com.aop.concurrent.annotations.Producer;
import com.aop.concurrent.annotations.Reader;
import com.aop.concurrent.annotations.Synchronized;
import com.aop.concurrent.annotations.Writer;

/**
 * Aspect for logging entries and leaves from critical sections
 * @author minowak
 */
public aspect LoggingAspect {
	declare precedence: SynchronizedAspect, LoggingAspect;

	private Map<String, String> locked = new HashMap<String, String>();

	/**
	 * Pointcut: methods with @Synchronized annotation.
	 *
	 * @param sync
	 * 			Synchronized annotation
	 */
	pointcut syncPoint(Synchronized sync) : execution(@Synchronized * *.*(..)) && @annotation(sync);

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
	 * Producer pointcut
	 * @param producer
	 */
	pointcut producerPoint(Producer producer) : execution(@Producer * *.*(..)) && @annotation(producer);

	/**
	 * Consumer pointcut
	 * @param producer
	 */
	pointcut consumerPoint(Consumer consumer) : execution(@Consumer * *.*(..)) && @annotation(consumer);

	/**
	 * Before @Reader.
	 *
	 * @param reader
	 */
	before(Reader reader) : readerPoint(reader) {
		String id = "MASTER";
		if(!reader.library().isEmpty()) {
			id = reader.library();
		}
		logEntry(id, thisJoinPoint.toString());
	}

	/**
	 * After @Reader.
	 *
	 * @param reader
	 */
	after(Reader reader) : readerPoint(reader) {
		String id = "MASTER";
		if(!reader.library().isEmpty()) {
			id = reader.library();
		}
		logExit(id, thisJoinPoint.toString());
	}

	/**
	 * Before @Writer.
	 *
	 * @param writer
	 */
	after(Writer writer) : writerPoint(writer) {
		String id = "MASTER";
		if(!writer.library().isEmpty()) {
			id = writer.library();
		}
		logEntry(id, thisJoinPoint.toString());
	}

	/**
	 * After @Writer.
	 *
	 * @param writer
	 */
	after(Writer writer) : writerPoint(writer) {
		String id = "MASTER";
		if(!writer.library().isEmpty()) {
			id = writer.library();
		}
		logExit(id, thisJoinPoint.toString());
	}

	/**
	 * Before @Producer.
	 *
	 * @param producer
	 */
	before(Producer producer) : producerPoint(producer) {
		String id = "MASTER";
		if(!producer.buffer().isEmpty()) {
			id = producer.buffer();
		}
		logEntry(id, thisJoinPoint.toString());
	}

	/**
	 * After @Producer.
	 *
	 * @param producer
	 */
	after(Producer producer) : producerPoint(producer) {
		String id = "MASTER";
		if(!producer.buffer().isEmpty()) {
			id = producer.buffer();
		}
		logExit(id, thisJoinPoint.toString());
	}

	/**
	 * Before @Consumer.
	 *
	 * @param consumer
	 */
	after(Consumer consumer) : consumerPoint(consumer) {
		String id = "MASTER";
		if(!consumer.buffer().isEmpty()) {
			id = consumer.buffer();
		}
		logEntry(id, thisJoinPoint.toString());
	}

	/**
	 * After @Producer.
	 *
	 * @param consumer
	 */
	after(Consumer consumer) : consumerPoint(consumer) {
		String id = "MASTER";
		if(!consumer.buffer().isEmpty()) {
			id = consumer.buffer();
		}
		logExit(id, thisJoinPoint.toString());
	}

	/**
	 * Before @Synchronized.
	 *
	 * @param sync
	 */
	before(Synchronized sync) : syncPoint(sync) {
		String id = "MASTER";
		if(!sync.id().isEmpty()) {
			id = sync.id();
		}
		logEntry(id, thisJoinPoint.toString());
	}

	/**
	 * After @Synchronized.
	 * @param sync
	 */
	after(Synchronized sync) : syncPoint(sync) {
		String id = "MASTER";
		if(!sync.id().isEmpty()) {
			id = sync.id();
		}
		logExit(id, thisJoinPoint.toString());
	}

	private void logEntry(String id, String name) {
		id += " " + System.currentTimeMillis();
		if(locked.get(id) == null) {
			log("[" +  id + "] Thread " + name + " entered critical section.");
			locked.put(id, name);
		} else {
			log("[" + id + "] ERROR: Thread " + name +
					" tried entering critical section while " + locked.get(id) + " is already there!");
		}
	}

	private void logExit(String id, String name) {
		id += " " + System.currentTimeMillis();
		log("[" + id + "] Thread " + name + " left critical section.");
		locked.put(id,  null);
	}

	private void log(String msg) {
		try {
		    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("log.txt", true)));
		    out.println(msg);
		    out.close();
		} catch (IOException e) {
		    //dont care
		}
	}
}

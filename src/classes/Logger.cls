/**
 * @group Logger
 * @description This class is the base logger for apex fluent logging
 */
public
without sharing class Logger {
	private
	String className;
	private
	String masterClassName;
	private
	static List<Log__c> masterLogs = new List<Log__c>();

	/**
	 * @description Singleton instance of the no-op API. It basically disgards all the
	 * chainable functions if the current log statement is not loggable.
	 */
	private
	static final NoOp NO_OP = new NoOp();

	/**
	 * @description Constructor for a new logger, which should only be initiated once
	 * for one class. The constructor will get the enclosing class/projects, which will
	 * be used to check the loggability in at(LoggingLevel level)
	 * @param className The current caller class's name
	 */
	public
	Logger (String className) {
		this.className = className;
		String masterClass = getEnclosingClass(className);
		this.masterClassName = masterClass;

	}

	/**
	 * @description Method to get the enclosing class/project of the current logging caller
	 * class, which will be used to query the appropriate loggability.
	 * @param logging caller class
	 * @return input class's enclosing class/project
	 * @TODO: add logic for getting the enclosing projects by file path or
	 *        from 'key-value' pair of 'class-project'. The method return empty
	 *        for now.
	 */
	private
	String getEnclosingClass (String className) {
		return '';
	}

	/**
	  * @description Insert master logs captured during transaction. This method is useful
	  *  if you want collect logs and insert it later (in batch processing/after API callouts)
	  */
	public
	void insertMasterLogs () {
		if (masterLogs.size() > 0) {
			upsert masterLogs;
		}

	}
	/**
	 * @description Returns a fluent logging API appropriate for the specified log level.
	 * If a logger implementation determines that logging is definitely
	 * disabled at this point then this method is expected to return a
	 * "no-op" implementation of the AbstractLogger, which will
	 * result in all further calls made for the log statement to being
	 * silently ignored. If the log statement is loggable, then create a new
	 * instance of LogContext, which contains the log data and related log
	 * logging behaviors.
	 * @param level The user-defined logging level
	 */
	private
	ILogContext at (LoggingLevel level) {
		if (isLoggable(level)) {
			return new LogContext(level, className);
		}
		else {
			return NO_OP;
		}
	}

	/** A convenience method for at(LoggingLevel.NONE). */
	public
	ILogContext atNone () {
		return at(LoggingLevel.NONE);
	}

	/** A convenience method for at(LoggingLevel.ERROR). */
	public
	ILogContext atError () {
		return at(LoggingLevel.ERROR);
	}

	/** A convenience method for at(LoggingLevel.WARN). */
	public
	ILogContext atWarn () {
		return at(LoggingLevel.WARN);
	}

	/** A convenience method for at(LoggingLevel.INFO). */
	public
	ILogContext atInfo () {
		return at(LoggingLevel.INFO);
	}

	/** A convenience method for at(LoggingLevel.DEBUG). */
	public
	ILogContext atDebug () {
		return at(LoggingLevel.DEBUG);
	}

	/** A convenience method for at(LoggingLevel.FINE). */
	public
	ILogContext atFine () {
		return at(LoggingLevel.FINE);
	}

	/** A convenience method for at(LoggingLevel.FINER). */
	public
	ILogContext atFiner () {
		return at(LoggingLevel.FINER);
	}

	/** A convenience method for at(LoggingLevel.FINEST). */
	public
	ILogContext atFinest () {
		return at(LoggingLevel.FINEST);
	}

	/**
	 * @description Returns whether the given level is enabled for this logger.
	 * It is always a good programming practice to prefix log statements with
	 * a check for 'loggability' by calling Logger.isLoggable(Level) prior to
	 * logging. The configurable loggability keep the prod log from verbose
	 * and give developer flexibility in development. The loggability is
	 * defined in custom setting for specific enclosing class, if the
	 * enclosing class is not in custom setting, return the default
	 * loggability setting. This method is called by at(LoggingLevel level)
	 * before start logging.
	 * @param level The user-defined logging level
	 * @TODO: enable loggablity by defining the enclosing class/projects,
	 *        and configure loggability with custom metadata. For now, this
	 *        method will return true by default.
	 */
	private
	boolean isLoggable (LoggingLevel level) {
		return true;
	}

	/**
	 * @group Logger
	 * @description This class is LogConext class for base logger, which
	 *              perform the basic logging behaviors.
	 */
	public
	class LogContext implements ILogContext {
		private
		String className;
		private
		String methodName;
		private
		Integer lineNumber;
		private
		LoggingLevel level;
		private
		List<Log__c> logs;
		private
		String recordId;
        private
		String message;

		public
		LogContext (LoggingLevel level, String className) {
			this.level = level;
			this.className = className;
			logs = new List<Log__c>();
		}

		/**
		 * @description Associates an exception instance with the current log statement, to
		 * be interpreted as the cause of this statement. Typically this method
		 * will be used from within catch blocks to log the caught exception or
		 * error. If the cause is null then this method has no effect.
		 * The exception location, such as class name, method name and line
		 * number could be fetched in run time.
		 * withCause(Exception e) and
		 * withCause(
		 *    List<object> results,
		 *    String className,
		 *    String methodName,
		 *    Integer lineNumber)
		 * should not be called together at the same LogContext instance.
		 * @param Exception e
		 * @return chainable LogContext
		 */
		public
		LogContext withCause (Exception e) {
			Log__c log = new Log__c(Class__c = className,
					Exception_Type__c = e.getTypeName(),
					Line_Number__c = e.getLineNumber(),
					Method__c = getMethodName(e),
					Level__c = String.valueOf(level),
					Message__c = e.getMessage(),
					RecordId__c = recordId,
					Stack_Trace__c = e.getStackTraceString());
			logs.add(log);
			System.debug(System.LoggingLevel.INFO, '### masterLogs before : ' + masterLogs.size());
			masterLogs.add(log);
			System.debug(System.LoggingLevel.INFO, '### masterLogs after : ' + masterLogs.size());
			//system.debug(LoggingLevel.INFO,'-- >> logs :'+logs);
			return this;
		}

		/**
		 * @description Associates a List of saveResult with the current log statement, to be
		 * interpreted as the cause of this statement.
		 * @param List<Database.SaveResult> dmlResults
		 * @return chainable LogContext
		 */
		public
		LogContext withCause (List<Database.SaveResult> dmlResults) {
			if (dmlResults == null || dmlResults.size() == 0) return this;
			for (Integer i = 0; i < dmlResults.size(); i++) {
				if (!dmlResults[i].isSuccess()) {
					recordId = dmlResults[i].getId();
					stageDmlErrors(dmlResults[i].getErrors());
				}
			}
			return this;
		}

		/**
		 * @description Associates a List of DeleteResult with the current log statement, to be
		 * interpreted as the cause of this statement.
		 * @param List<Database.DeleteResult> dmlResults
		 * @return chainable LogContext
		 */
		public
		LogContext withCause (List<Database.DeleteResult> dmlResults) {
			if (dmlResults == null || dmlResults.size() == 0) return this;
			for (Integer i = 0; i < dmlResults.size(); i++) {
				if (!dmlResults[i].isSuccess()) {
					recordId = dmlResults[i].getId();
					stageDmlErrors(dmlResults[i].getErrors());
				}
			}
			return this;
		}

		/**
		 * @description Associates a List of UndeleteResult with the current log statement, to be
		 * interpreted as the cause of this statement.
		 * @param List<Database.UndeleteResult> dmlResults
		 * @return chainable LogContext
		 */
		public
		LogContext withCause (List<Database.UndeleteResult> dmlResults) {
			if (dmlResults == null || dmlResults.size() == 0) return this;
			for (Integer i = 0; i < dmlResults.size(); i++) {
				if (!dmlResults[i].isSuccess()) {
					recordId = dmlResults[i].getId();
					stageDmlErrors(dmlResults[i].getErrors());
				}
			}
			return this;
		}

		/**
		 * @description Associates a List of UpsertResult with the current log statement, to be
		 * interpreted as the cause of this statement.
		 * @param List<Database.UpsertResult> dmlResults
		 * @return chainable LogContext
		 */
		public
		LogContext withCause (List<Database.UpsertResult> dmlResults) {
			if (dmlResults == null || dmlResults.size() == 0) return this;
			for (Integer i = 0; i < dmlResults.size(); i++) {
				if (!dmlResults[i].isSuccess()) {
					recordId = dmlResults[i].getId();
					stageDmlErrors(dmlResults[i].getErrors());
				}
			}
			return this;
		}

		/**
		 * @description Method to pass related method name into logger if it is not catched
		 * by Logger automatically
		 * @param methodName the related method name of current logging statements
		 * @return chainable LogContext
		 */
		public
		LogContext withMethod (String methodName) {
			this.methodName = methodName;
			return this;
		}
        
        /**
		 * @description Method to pass related method name into logger if it is not catched
		 * by Logger automatically
		 * @param methodName the related method name of current logging statements
		 * @return chainable LogContext
		 */
		public
		LogContext withMessage (String msg) {
			this.message = msg;
			return this;
		}

		/**
		 * @description Method to pass related ling number into logger if it is not catched
		 * by Logger automatically
		 * @param lineNumber the related line number of code that the logger is trying to log
		 * @return chainable LogContext
		 */
		public
		LogContext withLineNumber (Integer lineNumber) {
			this.lineNumber = lineNumber;
			return this;
		}

		public
		ILogContext withRecordId (String recordId) {
			this.recordId = recordId;
			return this;
		}
		/**
		 * @description Method for performing the logging.
		 */
		public
		void log () {
			system.debug(LoggingLevel.INFO, '-- >> logs :' + logs);
			if (logs.size() > 0) {
				insert logs;
			}

		}

		/**
		 * @description Method for performing the simple logging with message input.
		 * This method should not be called with withCause() at the same time.
		 * @param message to log
		 */
		public
		void log (String message) {
            Log__c log = new Log__c();
            log.Level__c = String.valueOf(level);
			log.Class__c = className;
			log.Method__c = methodName;
			log.RecordId__c = recordId;
			log.Message__c = message;

			insert log;
		}

		/**
		 * @description Method for getting logging caller method name from stack trace for
		 * standard exceptions.
		 * @param standard exception e
		 * @return method name
		 */
		private
		String getMethodName (Exception e) {
			String trace = e.getStackTraceString();
			if (String.isEmpty(trace) || !trace.startsWith('Class.')) {
				return null;
			}
			else {
				return trace.substringBefore(':').subStringAfterLast('.');
			}
		}

		/**
		 * @description Method for create/stage a list of logs from DML errors
		 * @param List<Database.Error> errs from DML results (saveResult,
		 *        DeleteResult, UndeleteResult and UpsertResult
		 *        of Database namespace).
		 */
		private
		void stageDmlErrors (List<Database.Error> errs) {
			Integer iCount = 0;
			for (Database.Error err : errs) {
				Log__c log = new Log__c(Class__c = className,
						Exception_Type__c = String.valueOf(err.getStatusCode()),
						Line_Number__c = lineNumber,
						Method__c = methodName,
						RecordId__c = recordId,
						Level__c = String.valueOf(level),
						Message__c = iCount + ' of ' + errs.size() + ' : ' + err.getMessage());
				logs.add(log);
				masterLogs.add(log);
				iCount++;
			}
		}

		/**
		   * @description Method for stage a list of logs
		   * @param Log__c log - Log instance you need to stage
		   */
		public
		void stageLog (Log__c log) {
			log.Level__c = String.valueOf(level);
			log.Class__c = className;
			log.Method__c = methodName;
			log.RecordId__c = recordId;

			this.logs.add(log);
			masterLogs.add(log);
			//system.debug(LoggingLevel.INFO,'-- >> logs :'+logs);
		}
	}
}
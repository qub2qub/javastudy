/*
 * Copyright 2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package de.olivergierke.whoops.options;

import de.olivergierke.whoops.core.Instrument;

/**
 * 
 * @author Oliver Gierke
 */
public class Option extends Instrument {

	private Instrument underlying;

	public Option(Instrument underlying) {
		super(underlying.getIssuer());
		this.underlying = underlying;
	}

	/**
	 * @return the underlying
	 */
	public Instrument getUnderlying() {
		return underlying;
	}
}

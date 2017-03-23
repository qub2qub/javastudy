/*
 * Copyright 2011-2013 the original author or authors.
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
package de.olivergierke.whoops.service.customer;

import de.olivergierke.whoops.domain.customer.Customer;

/**
 * Component interface to expose business functionality for {@link Customer}s.
 * 
 * @author Oliver Gierke
 */
public interface CustomerService {

	/**
	 * Creates a new {@link Customer} with the given first and lastname.
	 * 
	 * @param firstname must not be {@literal null} or empty.
	 * @param lastname must not be {@literal null} or empty.
	 * @return
	 */
	Customer createCustomer(String firstname, String lastname);
}

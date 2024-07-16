/* -- Problem Statement: Find valid email id's
	A consumer electronics store in Warsaw, stores all the customer feedback in the feedback table. 
	The email id's mentioned by customers are then used by the store to contact customers to promote any upcoming sales.
	However, some of the customers while sharing feedback enter invalid email addresses.
	Write an SQL query to identify and return all the valid email address from the feedback table.

	A valid email address needs to have 3 parts:
		Part 1 is the username. A username can contain upper or lower case letters, numbers and special characters like underscore character "_", dot ".", hyphen "-". Username should always start with a letter. 
		Part 2 is the "@" symbol.
		Part 3 is the domain which needs to have 2 sub parts. First part contains upper or lower case letters followed by a dot symbol and then followed by 2 or 3 letters.
*/



select * from feedback
where email ~'^[a-zA-Z][a-zA-Z0-9_.-]*@[a-zA-Z]+\.[a-zA-Z]{2,3}$'



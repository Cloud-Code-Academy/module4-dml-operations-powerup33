/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Michelle Holman
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account newAccount = new Account();
        // Set some fields on the Account
        newAccount.Name = 'Acme';
        newAccount.BillingCity = 'Springfield';
        // Insert the Account into the database
        insert newAccount;
        // Return the Id of the newly created Account
        return newAccount.Id;
    }       //PASS


    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account instance
        Account newAccount = new Account();
        // Set the name and industry fields on the Account
        newAccount.Name = name;
        newAccount.Industry = industry;
        // Insert the Account
        insert newAccount;
    }       //PASS

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact();
        // Set the AccountId field on the Contact
        // Set Last Name to pass test class
        newContact.LastName = 'Company';
        newContact.AccountId = accountId;
        // Insert the Contact
        insert newContact;
        // Return the Id of the newly created Contact
        return newContact.Id;
    }       //PASS - had to add in fixed "LastName" to pass test class


    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact existingContact = [SELECT Id, LastName FROM Contact WHERE Id = :contactId];
        // Update LastName field on the Contact
        existingContact.LastName = newLastName;
        // Update the Contact in the database
        update existingContact;
    }       //PASS 


    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity existingOpp = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        // Update the Opportunity's stage
        existingOpp.StageName = newStage;
        // Update the Opportunity in the database
        update existingOpp;
    }       //PASS

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account acc = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId];
        
        // Check if the Account exists
        if (acc != null) {
            // Update the Account with the new name and industry
            acc.Name = newName;
            acc.Industry = newIndustry;
        
            // Update the Account in the database
            update acc;
        } else {
            // Handle the scenario where no Account is found with the provided Id
            System.debug('No Account found with Id: ' + accountId);
        }
    }




    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Set common values for each Opportunity
        String defaultStage = 'Qualification';
        Date defaultCloseDate = Date.today().addMonths(3);
        Decimal defaultAmount = 50000;
            // Iterate over the list of Opportunities
        for (Opportunity opp : opportunities) {
            // Set Opportunity fields
            opp.StageName = defaultStage;
            opp.CloseDate = defaultCloseDate;
            opp.Amount = defaultAmount;
        }
        // Upsert the list of Opportunities
        upsert opportunities;
    }       //PASS


    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Query the Account Id based on the provided accountName
        List<Account> accList = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
        Account acc;
        // If Account doesn't exist, create a new one
        if (acc == null) {
            acc = new Account(Name = accountName);
            insert acc;
        }
        // Convert oppNames list to a set to remove duplicates
        Set<String> uniqueOppNames = new Set<String>(oppNames);
        
        // Create a list to store Opportunity records
        List<Opportunity> opportunities = new List<Opportunity>();
        
        // Loop through each unique Opportunity name
        for (String oppName : uniqueOppNames) {
            // Create an Opportunity with the given name and associate it with the Account
            Opportunity newOpp = new Opportunity(
                Name = oppName,
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            );
            // Add the Opportunity to the list
            opportunities.add(newOpp);
            }
        
            // Upsert the Opportunity records
            upsert opportunities;
        }       //PASS


    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */

    public static Account upsertAccount(String accountName) {
    // Query for the Account
    List<Account> accounts = [SELECT Id, Description FROM Account WHERE Name = :accountName];
    Account acc;
    // Check if the Account already exists
    if (!accounts.isEmpty()) {
        // Update the description of the existing Account
        acc = accounts[0];
        acc.Description = 'Updated Account';
    } else {
        // Create a new Account
        acc = new Account(Name = accountName, Description = 'New Account');
    }
    // Perform upsert operation
    upsert acc;
    return acc;
}       //PASS


    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
         // Loop through each Contact
        for (Contact con : contactsToUpsert) {
            // Extract the Account Name from Contact's LastName
            String accountName = con.LastName;
        
            // Get or create an Account with the extracted name
            Account acc = upsertAccount(accountName);
        
            // Link the Contact to its Account using the Account Id
            con.AccountId = acc.Id;
        }
        
        // Upsert the Contacts
        upsert contactsToUpsert;
    }       //PASS

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // List to hold Lead records to be inserted
        List<Lead> leadsToInsert = new List<Lead>();
        
        // Loop through each Lead name
        for (String leadName : leadNames) {
            // Split lead name into first name and last name
            List<String> nameParts = leadName.split(' ');
            String firstName = nameParts.size() > 0 ? nameParts[0] : ''; // First part is first name
            String lastName = nameParts.size() > 1 ? nameParts[1] : ''; // Second part is last name
            String company = nameParts.size() > 2 ? nameParts[2] : '';  // Remaining parts are company
        
            // Create a Lead record and set its fields
            Lead newLead = new Lead();
            newLead.FirstName = firstName;
            newLead.LastName = lastName; // Set the Last Name field
            newLead.Company = company; // Set the Company field
            // Add the Lead record to the list
            leadsToInsert.add(newLead);
        }
            // Insert the Leads
            insert leadsToInsert;
        
            // Delete the Leads
            delete leadsToInsert;
    }       //PASS

    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // List to hold the cases to be inserted
        List<Case> casesToInsert = new List<Case>();
        // Loop through the number of cases
        for (Integer i = 0; i < numOfCases; i++) {
            // Create a new Case instance and set its fields
            Case newCase = new Case();
            newCase.AccountId = accountId; // Relate to the provided accountId
        }
        // Insert the cases
        insert casesToInsert;
        // Delete the cases
        delete casesToInsert;
    }       //PASS
}
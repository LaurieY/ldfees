Feature: Uploading feefile
    In order to have a file to process
    
    Scenario: Uploading a Feefile
        Given I am on the feefiles page
        When I follow "New Feefile"
         And I upload the file "public/fees/fees_template_sept.csv"
         And I press "feefile_submit"
         Then I should see "Feefile was successfully created."
        And I should be on the feefile show page for "fees_template_sept.csv"
    
    And I should see "Feefilename: fees_template_sept.csv "
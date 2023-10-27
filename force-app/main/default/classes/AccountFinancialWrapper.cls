//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
// The supplied json has fields with names that are not valid in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public class AccountFinancialWrapper {

    public List<Value> value {get;set;}

    public AccountFinancialWrapper(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'value') {
                        value = arrayOfValue(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'AccountFinancialWrapper consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

    public class Value {
        public String id {get;set;}
        public String number_Z {get;set;} // in json: number
        public String displayName {get;set;}
        public String type {get;set;}
        public String addressLine1 {get;set;}
        public String addressLine2 {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String postalCode {get;set;}
        public String phoneNumber {get;set;}
        public String email {get;set;}
        public String website {get;set;}
        public String salespersonCode {get;set;}
        public Double balanceDue {get;set;}
        public Integer creditLimit {get;set;}
        public Boolean taxLiable {get;set;}
        public String taxAreaId {get;set;}
        public String taxAreaDisplayName {get;set;}
        public String taxRegistrationNumber {get;set;}
        public String currencyId {get;set;}
        public String currencyCode {get;set;}
        public String paymentTermsId {get;set;}
        public String shipmentMethodId {get;set;}
        public String paymentMethodId {get;set;}
        public String blocked {get;set;}
        public String genBusPostingGroup {get;set;}
        public String vatBusPostingGroup {get;set;}
        public String custPostingGroup {get;set;}
        public String lastModifiedDateTime {get;set;}
        public String Date_Filter {get;set;}
        public String Global_Dimension_1_Filter {get;set;}
        public String Global_Dimension_2_Filter {get;set;}
        public String Currency_Filter {get;set;}
        public CustomersGTcustomerFinancialDetails CustomersGTcustomerFinancialDetails {get;set;}

        public Value(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'number') {
                            number_Z = parser.getText();
                        } else if (text == 'displayName') {
                            displayName = parser.getText();
                        } else if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'addressLine1') {
                            addressLine1 = parser.getText();
                        } else if (text == 'addressLine2') {
                            addressLine2 = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'country') {
                            country = parser.getText();
                        } else if (text == 'postalCode') {
                            postalCode = parser.getText();
                        } else if (text == 'phoneNumber') {
                            phoneNumber = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'website') {
                            website = parser.getText();
                        } else if (text == 'salespersonCode') {
                            salespersonCode = parser.getText();
                        } else if (text == 'balanceDue') {
                            balanceDue = parser.getDoubleValue();
                        } else if (text == 'creditLimit') {
                            creditLimit = parser.getIntegerValue();
                        } else if (text == 'taxLiable') {
                            taxLiable = parser.getBooleanValue();
                        } else if (text == 'taxAreaId') {
                            taxAreaId = parser.getText();
                        } else if (text == 'taxAreaDisplayName') {
                            taxAreaDisplayName = parser.getText();
                        } else if (text == 'taxRegistrationNumber') {
                            taxRegistrationNumber = parser.getText();
                        } else if (text == 'currencyId') {
                            currencyId = parser.getText();
                        } else if (text == 'currencyCode') {
                            currencyCode = parser.getText();
                        } else if (text == 'paymentTermsId') {
                            paymentTermsId = parser.getText();
                        } else if (text == 'shipmentMethodId') {
                            shipmentMethodId = parser.getText();
                        } else if (text == 'paymentMethodId') {
                            paymentMethodId = parser.getText();
                        } else if (text == 'blocked') {
                            blocked = parser.getText();
                        } else if (text == 'genBusPostingGroup') {
                            genBusPostingGroup = parser.getText();
                        } else if (text == 'vatBusPostingGroup') {
                            vatBusPostingGroup = parser.getText();
                        } else if (text == 'custPostingGroup') {
                            custPostingGroup = parser.getText();
                        } else if (text == 'lastModifiedDateTime') {
                            lastModifiedDateTime = parser.getText();
                        } else if (text == 'Date_Filter') {
                            Date_Filter = parser.getText();
                        } else if (text == 'Global_Dimension_1_Filter') {
                            Global_Dimension_1_Filter = parser.getText();
                        } else if (text == 'Global_Dimension_2_Filter') {
                            Global_Dimension_2_Filter = parser.getText();
                        } else if (text == 'Currency_Filter') {
                            Currency_Filter = parser.getText();
                        } else if (text == 'CustomersGTcustomerFinancialDetails') {
                            CustomersGTcustomerFinancialDetails = new CustomersGTcustomerFinancialDetails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Value consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class CustomersGTcustomerFinancialDetails_Z {
        public String id {get;set;}
        public String number_Z {get;set;} // in json: number
        public Double balance {get;set;}
        public Integer totalSalesExcludingTax {get;set;}
        public Integer overdueAmount {get;set;}
        public String Global_Dimension_1_Filter {get;set;}
        public String Global_Dimension_2_Filter {get;set;}
        public String Currency_Filter {get;set;}
        public String Date_Filter {get;set;}

        public CustomersGTcustomerFinancialDetails_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'number') {
                            number_Z = parser.getText();
                        } else if (text == 'balance') {
                            balance = parser.getDoubleValue();
                        } else if (text == 'totalSalesExcludingTax') {
                            totalSalesExcludingTax = parser.getIntegerValue();
                        } else if (text == 'overdueAmount') {
                            overdueAmount = parser.getIntegerValue();
                        } else if (text == 'Global_Dimension_1_Filter') {
                            Global_Dimension_1_Filter = parser.getText();
                        } else if (text == 'Global_Dimension_2_Filter') {
                            Global_Dimension_2_Filter = parser.getText();
                        } else if (text == 'Currency_Filter') {
                            Currency_Filter = parser.getText();
                        } else if (text == 'Date_Filter') {
                            Date_Filter = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CustomersGTcustomerFinancialDetails_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class CustomersGTcustomerFinancialDetails_W {
        public String id {get;set;}
        public String number_Z {get;set;} // in json: number
        public Integer balance {get;set;}
        public Integer totalSalesExcludingTax {get;set;}
        public Integer overdueAmount {get;set;}
        public String Global_Dimension_1_Filter {get;set;}
        public String Global_Dimension_2_Filter {get;set;}
        public String Currency_Filter {get;set;}
        public String Date_Filter {get;set;}

        public CustomersGTcustomerFinancialDetails_W(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'number') {
                            number_Z = parser.getText();
                        } else if (text == 'balance') {
                            balance = parser.getIntegerValue();
                        } else if (text == 'totalSalesExcludingTax') {
                            totalSalesExcludingTax = parser.getIntegerValue();
                        } else if (text == 'overdueAmount') {
                            overdueAmount = parser.getIntegerValue();
                        } else if (text == 'Global_Dimension_1_Filter') {
                            Global_Dimension_1_Filter = parser.getText();
                        } else if (text == 'Global_Dimension_2_Filter') {
                            Global_Dimension_2_Filter = parser.getText();
                        } else if (text == 'Currency_Filter') {
                            Currency_Filter = parser.getText();
                        } else if (text == 'Date_Filter') {
                            Date_Filter = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CustomersGTcustomerFinancialDetails_W consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class CustomersGTcustomerFinancialDetails_X {
        public String id {get;set;}
        public String number_Z {get;set;} // in json: number
        public Double balance {get;set;}
        public Integer totalSalesExcludingTax {get;set;}
        public Double overdueAmount {get;set;}
        public String Global_Dimension_1_Filter {get;set;}
        public String Global_Dimension_2_Filter {get;set;}
        public String Currency_Filter {get;set;}
        public String Date_Filter {get;set;}

        public CustomersGTcustomerFinancialDetails_X(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'number') {
                            number_Z = parser.getText();
                        } else if (text == 'balance') {
                            balance = parser.getDoubleValue();
                        } else if (text == 'totalSalesExcludingTax') {
                            totalSalesExcludingTax = parser.getIntegerValue();
                        } else if (text == 'overdueAmount') {
                            overdueAmount = parser.getDoubleValue();
                        } else if (text == 'Global_Dimension_1_Filter') {
                            Global_Dimension_1_Filter = parser.getText();
                        } else if (text == 'Global_Dimension_2_Filter') {
                            Global_Dimension_2_Filter = parser.getText();
                        } else if (text == 'Currency_Filter') {
                            Currency_Filter = parser.getText();
                        } else if (text == 'Date_Filter') {
                            Date_Filter = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CustomersGTcustomerFinancialDetails_X consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class CustomersGTcustomerFinancialDetails {
        public String id {get;set;}
        public String number_Z {get;set;} // in json: number
        public Double balance {get;set;}
        public Double totalSalesExcludingTax {get;set;}
        public Integer overdueAmount {get;set;}
        public String Global_Dimension_1_Filter {get;set;}
        public String Global_Dimension_2_Filter {get;set;}
        public String Currency_Filter {get;set;}
        public String Date_Filter {get;set;}

        public CustomersGTcustomerFinancialDetails(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'number') {
                            number_Z = parser.getText();
                        } else if (text == 'balance') {
                            balance = parser.getDoubleValue();
                        } else if (text == 'totalSalesExcludingTax') {
                            totalSalesExcludingTax = parser.getDoubleValue();
                        } else if (text == 'overdueAmount') {
                            overdueAmount = parser.getIntegerValue();
                        } else if (text == 'Global_Dimension_1_Filter') {
                            Global_Dimension_1_Filter = parser.getText();
                        } else if (text == 'Global_Dimension_2_Filter') {
                            Global_Dimension_2_Filter = parser.getText();
                        } else if (text == 'Currency_Filter') {
                            Currency_Filter = parser.getText();
                        } else if (text == 'Date_Filter') {
                            Date_Filter = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CustomersGTcustomerFinancialDetails consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class CustomersGTcustomerFinancialDetails_Y {
        public String id {get;set;}
        public String number_Z {get;set;} // in json: number
        public Integer balance {get;set;}
        public Double totalSalesExcludingTax {get;set;}
        public Integer overdueAmount {get;set;}
        public String Global_Dimension_1_Filter {get;set;}
        public String Global_Dimension_2_Filter {get;set;}
        public String Currency_Filter {get;set;}
        public String Date_Filter {get;set;}

        public CustomersGTcustomerFinancialDetails_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'number') {
                            number_Z = parser.getText();
                        } else if (text == 'balance') {
                            balance = parser.getIntegerValue();
                        } else if (text == 'totalSalesExcludingTax') {
                            totalSalesExcludingTax = parser.getDoubleValue();
                        } else if (text == 'overdueAmount') {
                            overdueAmount = parser.getIntegerValue();
                        } else if (text == 'Global_Dimension_1_Filter') {
                            Global_Dimension_1_Filter = parser.getText();
                        } else if (text == 'Global_Dimension_2_Filter') {
                            Global_Dimension_2_Filter = parser.getText();
                        } else if (text == 'Currency_Filter') {
                            Currency_Filter = parser.getText();
                        } else if (text == 'Date_Filter') {
                            Date_Filter = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CustomersGTcustomerFinancialDetails_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }


    public static AccountFinancialWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new AccountFinancialWrapper(parser);
    }

    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT ||
                    curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                    curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }



    private static List<Value> arrayOfValue(System.JSONParser p) {
        List<Value> res = new List<Value>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Value(p));
        }
        return res;
    }















}
enum Environment {
  sandbox,
  production,
}


enum TransactionStatusIdentifierType {
  msisdn,
  tillNumber,
  organizationShortCode,
}

enum AccountBalanceIdentifierType {
  msisdn,
  tillNumber,
  organizationShortCode,
}

enum TaxRemittanceSenderIdentifierType {
  msisdn,
  tillNumber,
  organizationShortCode,
}

enum TaxRemittanceReceiverIdentifierType {
  msisdn,
  tillNumber,
  organizationShortCode,
}

enum QRTransactionType {
  //Pay Merchant (Buy Goods)
  bg,
  //Withdraw Cash at Agent Till
  wa,
  //Paybill or Business number
  pb,
  //Send Money(Mobile number)
  sm,
  //Sent to Business. Business number CPI in MSISDN format
  sb,
}

enum ReversalReceiverIdentifierType {
  msisdn,
  tillNumber,
  organizationShortCode,
}

enum C2BRegisterUrlResponseType {
  completed,
  cancelled,
}

enum B2CPaymentType {
  salaryPayment,
  businessPayment,
  promotionPayment,
}

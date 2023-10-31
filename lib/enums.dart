enum TransactionStatusIdentifierType {
  msisdn, // Mobile Number
  tillNumber, // Till Number
  organizationShortCode, // Organization Short Code
}

enum AccountBalanceIdentifierType {
  msisdn, // Mobile Number
  tillNumber, // Till Number
  organizationShortCode, // Organization Short Code
}

enum TaxRemittanceSenderIdentifierType {
  msisdn, // Mobile Number
  tillNumber, // Till Number
  organizationShortCode, // Organization Short Code
}

enum TaxRemittanceReceiverIdentifierType {
  msisdn, // Mobile Number
  tillNumber, // Till Number
  organizationShortCode, // Organization Short Code
}

enum QRTransactionType {
  // Pay Merchant (Buy Goods)
  bg,
  // Withdraw Cash at Agent Till
  wa,
  // Paybill or Business number
  pb,
  // Send Money(Mobile number)
  sm,
  // Sent to Business. Business number CPI in MSISDN format
  sb,
}

enum ReversalReceiverIdentifierType {
  msisdn, // Mobile Number
  tillNumber, // Till Number
  organizationShortCode, // Organization Short Code
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

class PaymentMethodModel {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvvCode;
  final String imgUrl;
  final String name;

  PaymentMethodModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvvCode,
    this.imgUrl =
        'https://i.pinimg.com/564x/56/65/ac/5665acfeb0668fe3ffdeb3168d3b38a4.jpg',
    this.name = 'Master Card',
  });
}

List<PaymentMethodModel> savedCards = [
  PaymentMethodModel(
    id: '1',
    cardNumber: '123456789000112',
    cardHolderName: 'malak',
    expiryDate: '2/23',
    cvvCode: '999',
  ),
  PaymentMethodModel(
    id: '2',
    cardNumber: '123456789000110',
    cardHolderName: 'malak',
    expiryDate: '5/25',
    cvvCode: '998',
  ),
  PaymentMethodModel(
    id: '3',
    cardNumber: '123456789000113',
    cardHolderName: 'salah',
    expiryDate: '2/28',
    cvvCode: '991',
  ),
  PaymentMethodModel(
    id: '4',
    cardNumber: '123456789000111',
    cardHolderName: 'amal',
    expiryDate: '4/27',
    cvvCode: '909',
  )
];

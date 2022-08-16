import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green.shade700,
            title: Text('Terms and Condition',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 13),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Column(
                  children: [
                    Text('TERMS OF USE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ],
                ),
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                  child: Text('These Terms and Conditions govern your use of the psmuae.com website (the “psmuae.com site”), the Pakistan Supermarket stores ( products directly from Pakistan), the terms of any purchases that you make via The Pakistan Supermarket and psmuae.com site, and your relationship with the Pakistan Supermarket (“Pakistan Supermarket”, “psmuae.com”, “we” or “us”). Please read them carefully as they affect your rights and liabilities under the law. By using the site and/or registering on the site, you agree to these Terms and Conditions and to our Privacy and Cookies Policy.',
                  textAlign: TextAlign.justify,),
                ),
                  Column(
                    children: [
                      Text('BASIS OF USE OF THE PAKISTAN SUPERMARKET SITE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('1.1 The psmuae.com site is provided to you free of charge for your personal use subject to these Terms and Conditions and our Privacy Policy. By using the psmuae.com site you agree to be bound by these Terms and Conditions and our Privacy Policy.\n\n'
                        '1.2 These Terms and Conditions govern your use of the psmuae.com site in general, the products that you purchase in Pakistan Supermarket stores and on the psmuae.com site and all services provided in connection with them.',
                      textAlign: TextAlign.justify,),
                  ),
                  Column(
                    children: [
                      Text('REGISTRATION',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('2.1 To register on the psmuae.com site you must be over eighteen years of age.\n\n'
                        '2.2 You must ensure that the details provided by you on registration or at any other time are correct and complete.',
                      textAlign: TextAlign.justify,),
                  ),
                  Column(
                    children: [
                      Text('PASSWORD AND SECURITY',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('3.1 When you register to use the psmuae.com site you will be asked to create a password. You should keep this password confidential and not disclose it or share it with anyone. You will be responsible for all activities and orders that occur or are submitted under your password. If you know or suspect that someone else knows your password, you should notify us by contacting customer services immediately (see paragraph 24 below for contact details).\n\n'
                        '3.2 If psmuae.com has reason to believe that there is likely to be a breach of security or misuse of the psmuae.com site, we may require you to change your password or we may suspend your account in accordance with paragraph 21 below.',
                      textAlign: TextAlign.justify,),
                  ),
                  Column(
                    children: [
                      Text('INTELLECTUAL PROPERTY',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('4.1 The content of the psmuae.com site is protected by copyright, trademarks, database and other intellectual property rights. You may retrieve and display the content of the psmuae.com site on a computer screen, store such content in electronic form on disk (but not any server or other storage device connected to a network) or print one copy of such content for your own personal, non-commercial use, provided you keep intact all and any copyright and proprietary notices. You may not otherwise reproduce, modify, copy or distribute or use for commercial purposes any of the materials or content on the psmuae.com site without written permission from psmuae.com.\n\n'
                        '4.2 No License is granted to you in these Terms and Conditions to use any trademark of the Pakistan Supermarket stores and psmuae.com, or its affiliated companies.',
                      textAlign: TextAlign.justify,),
                  ),
                  Column(
                    children: [
                      Text('LIMITATIONS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('5.1 You may not use the psmuae.com site for any of the purposes set out below (this includes any use by you of the Community sites – see paragraph 6 below for further information about the Community sites):\n\n'
                        '1. Gaining unauthorized access to other computer systems.\n'
                        '2. Interfering with any other person’s use or enjoyment of the psmuae.com site.\n'
                        '3. Interfering or disrupting networks or websites connected to the psmuae.com site.\n'
                        '4. Making, transmitting or storing electronic copies of materials protected by copyright without the permission of the owner.\n'
                        '5. Transmitting material containing any form of advertising or promotion for goods and services, junk mail, chain letters or “spam” 6. Impersonating another person.\n'
                        '7. Referring to specific website addresses outside of the psmuae.com site.\n\n'
                        '5.2 psmuae.com reserves the right to refuse to post material on the psmuae.com site or to remove material already posted on the psmuae.com site. You must not try to re-post material that psmuae.com, has refused to post on the Pakistan Supermarket site or has previously been removed from the psmuae.com site.\n\n'
                        '5.3 You will be responsible for all losses, costs and expenses reasonably incurred by us, all damages awarded against us by a court and all sums paid by us as a result of any settlement agreed by us arising out or in connection with:\n\n'
                        '1. Any claim by any third party that the use of the psmuae.com site by you is defamatory, offensive or abusive, or of an obscene or pornographic nature, or is illegal or is in breach of any applicable law, regulation or code of practice.\n'
                        '2. Any claim by any third party that the use of the psmuae.com site by you infringes that third party’s copyright or other intellectual property rights of whatever nature.\n\n'
                        '5.4 By submitting material you are granting psmuae.com a perpetual, royalty-free, non-exclusive license to reproduce, modify, translate, make available, distribute and sublicense the material in whole or in part and in any form.',
                      textAlign: TextAlign.justify,),
                  ),
                  Column(
                    children: [
                      Text('USE OF COMMUNITY SITES',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('6.1 The psmuae.com site includes a number of community sites, which may allow users to interact with each other via message boards, and other user forums (the “Community sites”).\n\n'
                        '6.2 We advise you not to post or in any way reveal any of your personal details on the Community sites (for example, your address, telephone number or email).\n\n'
                        '6.3 The psmuae.com site does not control or moderate the content placed on the Community sites. However, psmuae.com reserves the right to refuse to post material, to remove material posted on the Community sites and to contact you in the event that there are concerns about the content you have added to a Community site. The site may review or edit the content of the Community sites.\n\n'
                        '6.4 psmaue.com makes no representations as to the validity of any opinion, advice, information or statement displayed on the message boards by third parties. You are solely responsible for the content of your messages posted on the message boards and the views expressed by individuals do not represent the views of psmuae.com.',
                      textAlign: TextAlign.justify,),
                  ),
                  Column(
                    children: [
                      Text('THIRD PARTY WEBSITES',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('As a convenience to psmuae.com customers, psmuae.com site may include links to other websites or material. psmuae.com is not responsible for any of these websites or material, which is beyond its control.',
                      textAlign: TextAlign.justify,),
                  ),
                  Column(
                    children: [
                      Text('AVAILABILITY OF THE PAKISTAN SUPERMARKET SITE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('9.1 psmuae.com aims to offer a fault-free service. However, if a fault occurs in the service you should report it to the customer services (see paragraph 24 below for contact details) or by email at support@psmuae.com and we will attempt to correct the fault as soon as we reasonably can.\n\n'
                        '9.2 psmuae.com site may occasionally restrict access to the site to allow for repairs, maintenance or the introduction of new facilities or services.\n\n'
                        '9.3. Some purchases made on the psmuae.com site will also be governed by specific product terms – If you are unsure about anything related to purchasing of any product please contact customer services for further assistance.',
                      textAlign: TextAlign.justify,),
                  ),
                  Column(
                    children: [
                      Text('DESCRIPTIONS AND PRICES OF PRODUCTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('10.1 We have taken care to describe and show products as accurately as possible. Despite this, products may vary from their descriptions; product images are for representation purposes only and may vary slightly from the actual product. If there is anything that you do not understand, or if you wish to obtain further information, please contact customer services (see paragraph 25 below for contact details). Descriptions/performances of products stated against each are based on the catalogue and technical literature printed by the manufacturers/agent. Therefore, the write up provided against each product is not that of psmuae.com and subject to change without prior notice.\n\n'
                        '10.2 Price may sometimes differ between the Pakistan Supermarket Stores and psmuae.com; you will be charged the price on the psmuae.com upon use of this site. We are under no obligation to honor any in-store price or promotion in the event that it differs from those on the psmuae.com site.\n\n'
                        '10.3 If, by mistake, we have underpriced a product, we will not be liable to supply that product to you at the stated price, provided that we notify you before we dispatch the product to you. In those circumstances, we will notify the correct price to you so you can decide whether or not you wish to order the product at that price. If you decide not to order the product, we will give you a full refund on any amount already paid for that product in accordance with our refund policy.\n\n'
                        '10.4 The payment may be processed prior to psmuae.com dispatch of the product that you have ordered. If we have to cancel the order after we have processed the payment, the said amount will be reversed back to your credit card account. No cash disbursement shall be made under any condition whatsoever.\n\n'
                        '10.5 The price of a product does not include the delivery charge, which will depend on the delivery method you choose and will be added during checkout.',
                      textAlign: TextAlign.justify,),
                  ),
                  Column(
children: [
Text('AVAILABILITY',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
],
),
                  Padding(
padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
child: Text('11.1 All products advertised are subject to availability or while stocks last (as may be applicable).\n\n'
    '11.2 We try to ensure that we always stock the full product range and will let you know if the product is out of stock. If for any reason beyond our reasonable control we are unable to supply a particular product, we will not be liable to you except to ensure that you are not charged for that product.\n\n'
    '11.3 In the interests of all our customers, we may place restrictions on bulk buying of some products. psmuae.com reserves the right at our sole discretion, to limit the quantity per person, per household or per order. The said limitations may be applicable to orders placed by the same account, the same credit card and also to orders that use the same billing and/or shipping address. psmuae.com will provide notification to the customer should such limits be applied.\n',
textAlign: TextAlign.justify,),
),
                  Column(
                  children: [
                  Text('ACCEPTANCE OF ORDERS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ],
              ),
                  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                child: Text('12.1 Your order is an offer to buy from us. We will send you an order acknowledgement email detailing the products you have ordered.\n\n'
                    '12.2 Nothing that we do or say will amount to any acceptance of your offer until we send you an email notifying you of the order acknowledgment. At this point, a contract will be made between us for you to buy and for us to sell the products that you have ordered from us.\n\n'
                    '12.3 After the time the contract is made, you cannot amend your order (but please see your right to cancel an order in paragraph 15 below).\n\n'
                    '12.4 At any point up until the contract is made, we may decline to supply a product to you. If we decline to supply a product to you and you have already paid for it, we will give you a full refund of any amount already paid for that product in accordance with our refund policy in paragraphs 16 & 17 below.\n',
                textAlign: TextAlign.justify,),
                ),
                      Column(
                      children: [
                      Text('DELIVERIES',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('13.1 Delivery will be made to the address specified when you complete the order. At point of delivery, identity verification of the Consignee by sighting either an original labour card, passport, driving license, Emirates ID, Free zone ID to support consignee verification, will be required by our courier partners.\n\n'
                        '13.2 Please note that we do not do international shipping.\n\n'
                        '13.3 We use a variety of delivery methods, depending on the size of the product you order. Some products are delivered directly by our supplier and the supplier will contact you to arrange delivery.\n\n'
                        '13.4 At any point up until the contract is made, we may decline to supply a product to you. If we decline to supply a product to you and you have already paid for it, we will give you a full refund of any amount already paid for that product in accordance with our refund policy in paragraphs 16 & 17 below.\n\n'
                        '13.5 Whilst we make considerable effort to deliver all your products within 48 working hours of the date of your order, we shall not be liable if we fail to do so in part or in full due to circumstances beyond our control. We shall contact you to let you know if we are having any problems getting a product to you within that time. Supplier delivered products for areas outside of main city limits that are classed as remote or semi remote may take up to 5 working days dependent on supplier schedules.\n\n'
                        '13.5 Before ordering online you should check the following:\n'
                        '1. The item will fit through the doors.\n'
                        '2. The item will fit the exact space allocated in your house.\n'
                        '3. There is a clear path between the road and your front door.\n'
                        '4. If you live in an apartment, the lift is adequate to take delivery in size and weight.\n'
                        '5. If there are any access difficulties, please inform us in advance, on the day you should ensure that:\n'
                        '6. There is a clear path to your house.\n'
                        '7. Your floors are covered to prevent scuffing.\n'
                        '8. Any delicate objects are put in a safe place.\n',
                    textAlign: TextAlign.justify,),
                   ),
                      Column(
                      children: [
                      Text('CANCELLING YOUR ORDER IF YOU CHANGE YOUR MIND',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('14.1 If you the customer cancel the order, psmuae.com shall cancel the order as per your request. However, the online transaction charges will not be refunded. The cost of delivering and re-picking charges will apply if the product has been shipped. psmuae.com will not be able to cancel orders that have already been shipped. psmaue.com has the full right to demonstrate whether an order has been shipped or not. The customer agrees not to dispute the decision made by psmuae.com and accept psmuae.com decision regarding the cancellation.\n\n'
                        '14.2 For details of how to cancel your order please visit our returns and refunds page or contact customer support on support@psmuae.com.\n',
                    textAlign: TextAlign.justify,),
                    ),
                      Column(
                      children: [
                      Text('FAULTY PRODUCTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('If your products arrive damaged or they are faulty, you may return them and obtain a refund or replacement product. Please visit our returns and refunds for details of how to return them and details of our replacement and refund policy.\n',
                    textAlign: TextAlign.justify,),
                    ),
                  Column(
                    children: [
                      Text('REFUNDS ON PSMUAE.COM',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('If you are entitled to a refund, we will refund you according to the following criteria:\n\n'
                        '16.1 psmuae.com is unable to procure products: a reasonable time of 7-10 days from the date of authorization has to be given.\n'
                        '16.2 Products are not working upon delivery.\n'
                        '16.3 Products are lost in deliveries.\n'
                        '16.4 Product cannot be repaired.\n'
                        '16.5 Refunds for products purchased under a promotional offer will be based on the terms of the promotional price.\n'
                        '16.6 Refund settlement will only be affected once the bank has refunded the money, which is the next billing cycle from the date of application of refund.\n'
                        '16.7 psmuae.com will refund the delivery charge in full if you return all products of your order at the same time. If you choose to keep some of the products, we may retain the balance of the delivery charge that applies to the products you keep.\n'
                        '16.8 Please keep all items with their complete packaging and inside packaging intact if you intend to refund any items within the conditions set out. No exchange or refund will be considered without it.\n'
                        '16.9 We provide 7 Days money back guarantee if you change your mind, provided that the merchandise is as new, in a re-sellable condition and the consumables ( cartridges, blank tapes, CD’s or DVD’s) and accessories ( cables, chargers, batteries…) are still sealed, refund can be granted upon approval of psmuae.com within 7 days after delivery. (Exceptions apply). However, the normal delivery or supplier delivery charge as well as card transaction charges will be charged back as well as any additional charges incurred by courier collection.\n',
                      textAlign: TextAlign.justify,
                  ),





                  ),
                  Column(
                  children: [
                  Text('EXCHANGE/RETURNS POLICY FOR SUPERMARKET DEPARTMENT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ],
              ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                child: Text('Sections in the department:\n'
                    '1. Beverages – Cold, Juice, Drinks (long life)\n'
                    '2. Water, Sugar\n'
                    '3. Pet Care\n'
                    '4. Grocery – Food\n'
                    '5. Grocery – Non-food\n'
                    '6. Health and Beauty\n'
                    '7. Chilled and Dairy\n\n'
                    '17.1 Goods returned within seven (7) days will be exchanged for items of the same value, provided that the goods returned have not been used in any way and are not opened with original pos invoice.\n\n'
                    '17.2 If the customer does not want to use the item for whatsoever reasons, carries a receipt and have not been used, then the same could be exchanged or a credit note could be issued if the customer insists.\n\n'
                    '17.3 All product exchanges, product returns, exchange voucher, and credit notes should be approved with the signature of manager on duty, as well as verifying the product matching with serial number (perusable items to be cleared instantly).\n\n'
                    '17.4 If the purchased product is past its expiry date.\n\n'
                    '17.5 If a product is defective (to be verified based on T&Cs printed on warranty invoice stationery), the Pakistan Supermarket will first try to repair it. If it is not repairable, then the item will be exchanged for the same value.\n\n'
                    '17.6 For the products that cannot be repaired or exchanged, an exchange voucher / credit note will be issued. Respective store management reserves the right to take decisions on refund. Refund is only done upon approval of store management concerned.\n\n'
                    '17.7 If the customer brings products that are found to be spoilt at the time of purchase, or the goods are not of satisfactory quality, the customer service supervisor, with the consent of manager on duty and with the assistance of the section supervisor, can follow the normal procedures of exchange, return and refund.\n\n',
                textAlign: TextAlign.justify,),
                ),
                 Column(
                      children: [
                      Text('EXCLUSION FROM EXCHANGE/RETURN',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('18.1 Due to hygienic reasons, no exchange, return or refund will be offered on lingerie, cosmetics, perfumes, and personal grooming products, like shavers, trimmers, and epilators once used.\n\n'
                        '18.2 For frozen foods, chilled and dairy products on which temperature inconsistencies can happen, we do not provide any exchange, return and refund once sold and taken out from the store (be the case of a purchase made on the same day with the limited time as well temperature).\n\n'
                        '18.3 Products damaged while being used do not qualify for repair, exchange or refund, in reference to physical damage.\n',
                    textAlign: TextAlign.justify,),
                    ),
                     Column(
                      children: [
                      Text('EXCHANGE/RETURNS POLICY – FRESH FOOD DEPARTMENT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('Sections in the department:\n'
                        'Sections in the department:\n'
                        '2. Fruits and vegetable\n'
                        '3. Bakery\n'
                        '3. Bakery\n'
                        '6. In-house kitchen (ready-to-eat food)\n'
                        '7. Meat\n'
                        '8. Fish\n\n'
                        '19.1    As a rule, there is no exchange and return on fresh food items once sold and taken out from the store.\n\n'
                        '19.2    On perishables, there is no exchange and refund. However, if it is spoilt at the time of purchase, an exchange could be provided.\n\n'
                        '19.3   If the customer has purchased a wrong product and is returning the same immediately after the purchase, an exchange note could be considered.\n\n'
                        '19.4    An item which is past its expiry date qualifies for exchange.\n\n'
                        '19.5    If the product is not of the quality expected, the same can be returned within the same day of purchase and an exchange note could be issued. Exchange could be considered, as long as it is supported by the original receipt or invoice.\n\n'
                        '19.6    If the customer insists for return, customer service supervisor can always contact the supervisor concerned for further assistance.\n\n'
                        '19.6    If the customer insists for return, customer service supervisor can always contact the supervisor concerned for further assistance.\n\n'
                        '19.8    Exchange voucher, credit note and refund could be used as a last resort to retain the customer and prevent churn.\n\n'
                        '19.9    All product exchanges, product returns and exchange voucher/credit  notes should have the approval and signature of manager on duty.\n',
                    textAlign: TextAlign.justify,),
                    ),
                      Column(
                      children: [
                      Text('EXCHANGE/RETURNS POLICY -DEPARTMENT STORE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('Sections in the department:\n'
                        '1. Stationery\n'
                        '2. Household\n'
                        '3. Electronics / Home Appliances\n'
                        '4. Toys and sports\n'
                        '5. Telecom (recharge coupons and SIM cards)\n\n'
                        '20.1    Goods returned within seven (7) days will be exchanged for items of the same value, provided that the goods returned have not been used in any way and is not opened with original pos invoice as well as matching with the serial number (where-ever it can be applied).\n\n'
                        '20.2    Goods returned should be in their original condition and packaging. The item(s) are unworn, unwashed, not used, altered, soiled or damaged and in a sale-able condition.\n\n'
                        '20.3    Returned product needs to be in a condition deemed fit for resale.\n\n'
                        '20.4    A returned product, which is ordered and invoiced but is not delivered, could be accepted for exchange, return or refund.\n\n'
                        '20.5    For delivered items, if the customer opens the package and discovers an item that is damaged, the product is eligible for exchange, return or refund.\n\n'
                        '20.6    All product exchanges, product returns and exchange voucher / credit notes should be approved with the signature of manager on duty.\n\n'
                        '20.7    If the product does not last a reasonable time or the complaint is notified off at the desk within a reasonable time or is not in a reasonable condition, it could be accepted for exchange, return or refund.\n\n'
                        '20.8    If a wrong product is purchased or is sold by the merchandiser/the Pakistan Supermarket staff.\n\n'
                        '20.9    Provision of exchange is applicable in case there is a manufacturing defect in the product (for products from toys/sports sections).\n\n'
                        '20.10   If the product is found to be not working properly or having any manufacturing defects (in the case of products from Home appliances/Electronics section), the same need to be sent for repair.\n\n'
                        '20.11   If the item is not repairable, then it will be exchanged for the same value.\n\n'
                        '20.12   For the products that cannot be repaired or exchanged, an exchange voucher / credit note will be issued. Store management reserves the right to take decisions on refund.\n\n'
                        '20.13  Refund is provided only at the approval of store management concerned.\n\n'
                        '20.14   After-sales service is applicable on products like products provided by the authorized service centre of the respective manufacturers based on their warranty terms and conditions.\n\n'
                        '20.15   It shall be the complete discretion of the store management concerned to issue exchange voucher / credit note and provide refund to be provided to retain the customer. It is again based on the discretion of the concerned management to prevent churn. Refund to be provided only at the approval of store management concerned and should be considered as the last option to solve the customer grievance.\n\n'
                        '20.16 Products that are damaged while in use do not qualify for repair, exchange or refund.\n',
                        textAlign: TextAlign.justify
                    ),



                    ),
                      Column(
                      children: [
                      Text('ISSUING AN EXCHANGE VOUCHER / CREDIT NOTE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('21.1 A time bound exchange voucher / credit note is issued by the Pakistan Supermarket to the customer, which is equivalent to the product value as per the original Proof of Purchase.\n\n'
                        '21.2 Goods spoiled or damaged within the warranty period could not be serviced.\n\n'
                        '21.3 When they do not meet the customer’s specifications and the customer insists to get the items returned & is in its Original Packing.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('PROCEDURES FOR ISSUING AN EXCHANGE VOUCHER / CREDIT NOTE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                          textAlign: TextAlign.justify),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('22.1 Customer must present the original invoice (bill) at the customer service desk.\n\n'
                        '22.2 In normal return process, an exchange voucher/customer tax credit note can be issued with the consent and approval of the Section Supervisor, Customer Service Manager and the Manager on duty.\n\n'
                        'Products returned after seven (7) days need special consideration and the General Manager must mandatorily be informed in cases where the customer returns are more than seven (7) days after purchase.\n'
                        '1. In emergency situations, if the manager on duty is not reachable and the section staff member agrees to take back the item, an exchange voucher / credit note could be issued to the customer concerned after the customer service staff informs the General Manager.\n'
                        '2. The immediate next Duty Manager must verify the exchange deposit and physically verify the product with the Section Supervisor.\n'
                        '3. It is mandatory to fill the following details on the Customer “Tax Credit Note:”.\n'
                        '4. Customer Name & Mobile number.\n'
                        '5. Name and Signature of Section staff/Section Supervisor, Customer Service Manager and Duty Manager.\n\n'
                        'All approvals must be done on the spot of customer return by verifying the product and should not be done at the end of the day.\n'
                        '1. This approved Customer Tax Credit Note must be retained at the Customer Service desk always and handed over to the Cash Office at End of Day Operations.\n'
                        '2. The Accountant present at Cash Office must verify that all Customer Tax Credit Notes received are approved by all three (3) approvers.\n\n'
                        '22.3 Exchange voucher / tax credit note issued once could be redeemed within the validity period mentioned on the same. Exchange voucher / credit note issued may be redeemed in the store which issued the customer.\n\n'
                        'Customer relations supervisor should select the item from the bill, put a tick on the item to be returned, and scan the barcode of the receipt, or can enter the details from the receipt manually into the POS machine. A sample of the receipt is mentioned on the right side for reference. Details to be entered include Store number, POS number and receipt number. Once entered, the system will retrieve the receipt details and the supervisor needs to select the item that needs to be returned from the receipt. Go to the return option in the POS machine, select, enter the amount correctly and should make sure that the POS machine is showing a negative amount. Scan the exchange deposit code and press total to get the exchange voucher / credit note. Customer relations supervisor should put a tick on the item returned (the same needs to be done on the original receipt as well as on the exchange deposit receipt as well). No refund will be provided on exchange voucher / credit notes once issued.\n\n'
                        'When signing the exchange voucher / credit note, the customer service supervisor must write the name of the person who approved it.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('PAYMENTS AND CARDS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('23.1 Payment for your products will be taken at the time you place your order. Payments are done via Emirates NBD operating on a professional third-party cyber source payment gateway.\n\n'
                        '23.2 Your credit/debit card details will be encrypted to the highest standard and held on the Cyber source Host payment gateway, secure from hackers.\n\n'
                        '23.3 When ordering from the psmuae.com, we accept orders only from web browsers that permit communication through Secure Socket Lawyer (SSL) technology, for example a 7.0 version or higher of Internet Explorer, version 3.5 or higher of Firefox, Chrome version 10 or higher and Safari version 5 of higher. This means that you cannot inadvertently place an order through an unsecured connection.\n\n'
                        '23.4 All customers will be charged in local currency relating to the country of order. If a foreign currency credit card is used, then any differences between approximation in any foreign currency and actual billing price on the customer’s card bill statement is probably attributable to different credit card companies charging different exchange rates.\n',
                    textAlign: TextAlign.justify,),
                    ),
                     Column(
                      children: [
                      Text('FREE GIFTS AND PROMOTIONAL PRODUCTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('24.1 Free gifts and promotional products that are given away in conjunction with a purchase may be dispatched to you separately and delivery times may vary.\n\n'
                        '24.2  If you change your mind and return your product, you must also return any free gift or promotional product associated with the promotion and received by you as a result of that order. We may charge you a reasonable amount for the free gift if you do not return it.\n\n'
                        '',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('AMENDMENTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('We may update these Terms & Conditions from time to time and any changes will be notified to you via the e-mail address provided by you on registration or via a suitable announcement on the psmuae.com site. The changes will apply to the use of the psmuae.com site after we have given notice. If you do not wish to accept the new Terms and Conditions, you should not continue to use the psmuae.com site (including purchasing any products on the psmaue.com site). If you continue to use the psmuae.com site after the date on which the change comes into effect, your use of the psmaue.com site indicates your agreement to be bound by the new Terms and Conditions. These terms & conditions are updated on Feb 8, 2022.\n',
                    textAlign: TextAlign.justify,),
                    ),
                     Column(
                      children: [
                      Text('RIGHT TO SUSPEND OR CLOSE YOUR ACCOUNT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('We may update these Terms & Conditions from time to time and any changes will be notified to you via the e-mail address provided by you on registration or via a suitable announcement on the psmuae.com site. The changes will apply to the use of the psmuae.com site after we have given notice. If you do not wish to accept the new Terms and Conditions, you should not continue to use the psmuae.com site (including purchasing any products on the psmaue.com site). If you continue to use the psmuae.com site after the date on which the change comes into effect, your use of the psmaue.com site indicates your agreement to be bound by the new Terms and Conditions. These terms & conditions are updated on Feb 8, 2022.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('OUR RESPONSIBILITY TO YOU',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('27.1 The psmuae.com site is provided by the Pakistan Supermarket  LLC without any warranties or guarantees.\n\n'
                        '27.2 The psmuae.com site may provide content from other internet sites or resources and while psmuae.com tries to ensure that material included on the psmuae.com site is correct, reputable and of high quality, it cannot accept responsibility if this is not the case. psmaue.com will not be responsible for any errors or omissions or for the results obtained from the use of such information or for any technical problems, you may experience with the psmuae.com site. If psmuae.com is informed of any inaccuracies in the material on the psmuae.com site, we will attempt to correct the inaccuracies as soon as we reasonably can.\n\n'
                        '27.3 In particular, we disclaim all liabilities in connection with the following:\n'
                        '1. Incompatibility of the psmuae.com site with any of your equipment, software or telecommunications links.\n'
                        '2. Technical problems including errors or interruptions of the psmuae.com site.\n\n'
                        '27.4 If we are in breach of these Terms and Conditions, we will only be responsible for any losses that you suffer as a result to the extent that they are a foreseeable consequence to both of us at the time you order the relevant product or the time you otherwise use the psmuae.com site.\n\n'
                        '27.5 Because we sell products for personal use only, our responsibility to you shall not include any business losses, such as lost data, lost profits, lost sales or business interruption.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('MISCELLANEOUS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('28.1 You may not transfer any of your rights under these Terms and Conditions to any other person. We may transfer our rights under these Terms and Conditions to another business where we reasonably believe your rights will not be affected.\n\n'
                        '28.2 If you breach these Terms and Conditions and we choose to ignore this, we will still be entitled to use our rights and remedies at a later date or in any other situation where you breach these Terms and Conditions.\n\n'
                        '28.3 Neither party shall be responsible for any breach of these Terms and Conditions, caused by circumstances beyond that party’s control.\n\n'
                        '28.4 Except as expressly set out in these Terms and Conditions, all use of your personal information will be made in accordance with our Privacy and Cookies Policy.\n\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('CUSTOMER SERVICES',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('If you have any queries about online matters, please contact us online the Pakistan Supermarket Store, info@psmuae.com or via telephone: (+971) 06 745 6115 Saturday – Thursday 8.00 AM to 9.00 PM; Friday 2.00 PM to 9.00 PM. For retail concerns, please email us at support@psmuae.com.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('STANDARD E-COUPON TERMS & CONDITION',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('In addition to the rest of these Terms and Conditions, this paragraph 25 (the “E-Coupon Terms and Conditions”) applies specifically in addition to the use of electronic coupons issued by the Pakistan Supermarket (“E-Coupons”).\n\n'
                        'E-Coupons can only be used on the psmuae.com site, subject to these Terms and Conditions and any other specific conditions notified to you on the issue of an E-Coupon. No E-Coupon is redeemable through any website owned or operated by the Pakistan Supermarket s LLC or through any other the Pakistan Supermarket outlet (for instance, E-Coupons cannot be used for purchases from the Pakistan Supermarket Stores).\n\n'
                        'An E-Coupon is redeemed by entering its code at the appropriate point in the online purchase/checkout process. Redemption may be subject to you providing proof of entitlement to use the E-Coupon.\n\n'
                        'Your use of an E-Coupon indicates your agreement to be bound by the E-Coupon Terms and Conditions.\n\n'
                        'Psmuae.com reserves the right to withdraw or cancel an E-Coupon for any reason at any time.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('DISTRIBUTION OF E-COUPONS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('DISTRIBUTION OF E-COUPONS\n\n'
                        'The right to use an E-Coupon is personal to the original recipient and may not be transferred. No E-Coupon may be copied, reproduced, distributed, or published directly or indirectly in any form or by any means for use by an entity other than the original recipient, or stored in a data retrieval system, without the prior written permission of psmuae.com\n\n'
                        'E-Coupons distributed or circulated without the written approval of psmaue.com for example on an Internet message board, etc. are not valid for use and may be refused or cancelled.\n\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('PERMITTED USAGE OF E-COUPONS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('Unless expressly stated otherwise at the time of issue of the E-Coupon:\n'
                        'Unless expressly stated otherwise at the time of issue of the E-Coupon:\n'
                        '2. Only one E-Coupon will be valid for use per customer or household, as the case may be.\n'
                        '3. An E-Coupon may not be used in conjunction with any other special offer or E-Coupon.\n'
                        '4. E-Coupons cannot be exchanged for cash or used to purchase gift vouchers.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('EXCLUDED GOODS & SERVICES',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('Certain goods or services may be excluded from all E-Coupon offers. From time to time other goods or services may be excluded and any such further exclusion will be notified to you along with the E-Coupon or through the psmuae.com site.\n\n'
                        'E-Coupons may be limited to redemption in respect of certain products or services or certain products or services may be excluded from the ambit of use of the E-Coupon, in which case notice will be given to you at the time of issue of the E-Coupon.\n\n'
                        'Excluded goods and services will not count towards any qualifying conditions for offers and will not benefit from any promotional discount.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('MINIMUM SPEND REQUIREMENTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('Where the redemption of an E-Coupon is subject to a minimum spending requirement, the redemption is only permitted in respect of the purchase of qualifying products that will be communicated to you at the time of issue of the E-Coupon. Excluded products and supplementary charges, such as delivery shall not count towards a minimum spending requirement.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('CALCULATION OF DISCOUNT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('Where an online offer states that a percentage discount will be given on a purchase, the cost of the qualifying purchases will be reduced by the stated discount percentage.\n\n'
                        'Supplementary charges such as delivery charges shall not be discounted unless specifically stated in the offer description.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('SECURITY AND FRAUD',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('When you use an E-Coupon you warrant to psmuae.com that you are the duly authorized recipient of the E-Coupon and that you are using it in good faith.\n\n'
                        'If we reasonably believe that any E-Coupon is being used unlawfully we may reject or cancel any E-Coupon and you agree that you will have no claim against us in respect of any rejection or cancellation.\n\n'
                        'If we refuse an E-Coupon submitted as part of an order, for any reason, we will inform you before the order is dispatched to advise of the correct cost of the order and give you the opportunity to cancel the order.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('LIMITATION OF LIABILITY',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('Orders submitted with E-Coupons shall be accepted by psmuae.com in the usual way (as set out in paragraph 25 above).\n\n'
                        'psmuae.com shall not be liable to any customer for any financial loss arising out of the refusal, cancellation or withdrawal of any E-Coupon or any failure or inability of a customer to use an e-Coupon for any reason.\n',
                    textAlign: TextAlign.justify,),
                    ),
                    Column(
                      children: [
                      Text('VARIATION',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      textAlign: TextAlign.justify,),
                    ],
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                    child: Text('We reserve the right to vary or terminate the operation of any E-Coupon at any time without notice.\n\n'
                        'The psmuae.com site is owned and operated by the Pakistan Supermarket  LLC.\n',
                    textAlign: TextAlign.justify,),
                    ),



                ],),
            ),
          ),
        ));
  }
}

          //     Column(
          //     children: [
          //     Text('THIRD PARTY WEBSITES',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
          //     textAlign: TextAlign.justify,),
          //   ],
          // ),
          //   Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
          //   child: Text('',
          //   textAlign: TextAlign.justify,),
          //   ),
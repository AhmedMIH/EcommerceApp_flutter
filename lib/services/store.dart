import 'package:buy_it/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class Store {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  addProduct(Product product) async {
    await _fireStore.collection(kProductsCollection).add({
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductCategory: product.pCategory,
      kProductDescription: product.pDescription,
      kProductLocation: product.pLocation,
    });
  }

  Stream<QuerySnapshot> loadAllProduct() {
    return _fireStore.collection(kProductsCollection).snapshots();
  }

  Stream<QuerySnapshot> loadProductByCategory(String category) {
    return _fireStore
        .collection(kProductsCollection)
        .where(kProductCategory, isEqualTo: category)
        .snapshots();
  }

  deleteProduct(docId) {
    _fireStore.collection(kProductsCollection).doc(docId).delete();
  }

  editProduct(Product product) async {
    await _fireStore.collection(kProductsCollection).doc(product.pId).update({
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductCategory: product.pCategory,
      kProductDescription: product.pDescription,
      kProductLocation: product.pLocation,
    });
  }

  storeOrders(data, List<Product> products) {
    var documentRef = _fireStore.collection(kOrders).doc();
    documentRef.set(data);
    for (var product in products) {
      documentRef.collection(kOrderDetails).doc().set({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductQuantity: product.pQuantity,
        kProductLocation: product.pLocation,
        kProductCategory: product.pCategory
      });
    }
  }

  Stream<QuerySnapshot> loadOrders() {
    return _fireStore.collection(kOrders).snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    return _fireStore
        .collection(kOrders)
        .doc(documentId)
        .collection(kOrderDetails)
        .snapshots();
  }
}

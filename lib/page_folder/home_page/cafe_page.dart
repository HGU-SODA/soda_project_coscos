import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soda_project_final/provider/favorite_provider.dart';
import '../../app_color/app_color.dart';
import '../../firestore_file/firestore_cafes.dart';

class CafePage extends StatefulWidget {
  const CafePage({Key? key});

  @override
  State<CafePage> createState() => _CafePageState();
}

class _CafePageState extends State<CafePage> {
  Icon favoriteIcon = const Icon(Icons.favorite_border);

  bool _isSelected = false;

  final Set<int> _selectedItems = {};
  @override
  Widget build(BuildContext context) {
    final FirestoreServiseCafes firestoreService = FirestoreServiseCafes();
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getNotesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          // 데이터가 null이 아닌지 검사
          List notesList = snapshot.data!.docs;
          List<DocumentSnapshot> sortedNotesListLarge = List.from(notesList);
          sortedNotesListLarge.sort((a, b) {
            int priceA = a['price'];
            int priceB = b['price'];
            return priceB.compareTo(priceA);
          });

          List<DocumentSnapshot> sortedNotesListSmall = List.from(notesList);
          sortedNotesListSmall.sort((a, b) {
            int priceA = a['price'];
            int priceB = b['price'];
            return priceA.compareTo(priceB);
          });

          return Expanded(
            child: ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = sortedNotesListSmall[index];

                final isSelected = _selectedItems.contains(index);

                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;

                String name = data['name'] ?? ''; // null인 경우 빈 문자열 반환
                int price = data['price'] ?? 0; // null인 경우 0 반환
                String explain = data['explain'] ?? 'null'; // null인 경우 빈 문자열 반환
                String location = data['location'] ?? ''; // null인 경우 빈 문자열 반환
                String url = data["URL"] ?? 'null';

                FavoriteProvider favoriteProvider =
                    Provider.of<FavoriteProvider>(context);

                return SizedBox(
                  height: 162,
                  child: Card(
                    elevation: 0,
                    color: AppColor.backGroundColor2,
                    child: ListTile(
                      leading: SizedBox(
                          width: 113,
                          height: 124,
                          child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(url),
                          )),
                      title: Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.24,
                            ),
                          ),
                          const Text(' '),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.18,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            explain,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.18,
                            ),
                          ),
                          const SizedBox(height: 56),
                          Row(
                            children: [
                              Container(
                                width: 75,
                                height: 20,
                                padding: const EdgeInsets.only(top: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: AppColor.appBarColor1,
                                ),
                                child: Text(
                                  '${price.toString()}원~',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.18,
                                    color: AppColor.textColor4,
                                  ),
                                ),
                              ),
                              const Expanded(child: Text(' ')),
                              IconButton(
                                isSelected: _isSelected,
                                onPressed: () {
                                  setState(() {
                                    _isSelected = !_isSelected;

                                    if (isSelected) {
                                      _selectedItems.remove(index);
                                      favoriteProvider.deleteFavoriteCafe(name);
                                    } else {
                                      _selectedItems.add(index);
                                      favoriteProvider.addFavoriteCafe(name);
                                    }
                                  });
                                },
                                icon: (isSelected)
                                    ? Icon(Icons.favorite)
                                    : favoriteIcon,
                                style: ButtonStyle(
                                  iconColor: MaterialStatePropertyAll(
                                      AppColor.appBarColor1),
                                  backgroundColor: MaterialStatePropertyAll(
                                      AppColor.backGroundColor1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          // 에러가 발생한 경우 에러 메시지를 출력합니다.
          return Text('Error: ${snapshot.error}');
        } else {
          // 데이터가 아직 수신되지 않은 경우 로딩 표시를 표시합니다.
          return CircularProgressIndicator();
        }
      },
    );
  }
}
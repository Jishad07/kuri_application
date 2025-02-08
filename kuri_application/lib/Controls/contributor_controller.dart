import 'package:get/get.dart';
import 'package:kuri_application/Helpers/database_helper.dart';
import 'package:kuri_application/Models/Contributor.dart';

class ContributorController extends GetxController {
  // Observable list to manage contributors
  var contributors = <Contributor>[].obs;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // Fetch contributors from the database
  void fetchContributors() async {
    final List<Contributor> fetchedContributors = await dbHelper.getContributors();
    contributors.assignAll(fetchedContributors); // Updates the observable list
  }

  // Delete contributor from the database and list
  void deleteContributor(Contributor contributor) async {
    // Delete from the database
    await dbHelper.deleteContributor(contributor.id!);

    // Remove contributor from the observable list
    contributors.remove(contributor);
    
    // Optionally, show a confirmation message (this is for the UI feedback)
    Get.snackbar('Deleted', '${contributor.name} was deleted.');
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/outlined_textfield.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/models/exercise_for_customizaition.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/customize_workout_service.dart';
import 'package:fyp_flutter/views/account/workout_tracker/customized_workout_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class WorkoutForm extends StatefulWidget {
  const WorkoutForm({super.key});

  @override
  State<WorkoutForm> createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm> {
  List<ExerciseForCustomization> exercises = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController slugController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController noOfExercisePerSetController = TextEditingController();

  late AuthProvider authProvider;
  File? imageFile;
  bool isLoading = false;
  Map<int, int> selectedExercises = {};

  @override
  void initState() {
    super.initState();
    // Access the authentication provider
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    loadExercises();
  }

  void loadExercises() async {
    setState(() {
      isLoading = true;
    });
    var result = await CustomizeWorkoutService(authProvider).getExercises();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CustomizedWorkoutView()),
      (route) => false, // Remove all routes by returning false
    );
    setState(() {
      if (result != null && result != null) {
        exercises = List<ExerciseForCustomization>.from(
            result.map((item) => ExerciseForCustomization.fromJson(item)));
      }
      isLoading = false;
    });
  }

  void handleImageUpload() async {
    setState(() {
      isLoading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void addExercise(id) {
    setState(() {
      exercises.add(id);
    });
  }

  void removeExercise(int index) {
    setState(() {
      exercises.removeAt(index);
    });
  }

  void save(body) async {
    print(selectedExercises);
    await CustomizeWorkoutService(authProvider).saveCustomizedWorkout(
      body: body,
      image: imageFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return isLoading
        ? SizedBox(
            height: media.height, // Adjust height as needed
            width: media.width, // Adjust width as needed
            child: const Center(
              child: SizedBox(
                width: 50, // Adjust size of the CircularProgressIndicator
                height: 50, // Adjust size of the CircularProgressIndicator
                child: CircularProgressIndicator(
                  strokeWidth:
                      4, // Adjust thickness of the CircularProgressIndicator
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue), // Change color
                ),
              ),
            ),
          )
        : AuthenticatedLayout(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: TColor.white,
                centerTitle: true,
                elevation: 0,
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      "assets/img/black_btn.png",
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Text(
                  "Create Workout",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: exercises.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OutlinedTextField(
                              controller: nameController,
                              icon: const Icon(Icons.play_for_work_outlined),
                              slugController: slugController,
                              hitText: 'Name',
                            ),
                            SizedBox(
                              height: media.width * 0.04,
                            ),
                            OutlinedTextField(
                                controller: slugController,
                                icon: const Icon(Icons.play_for_work_outlined),
                                hitText: 'Slug',
                                readOnly: true),
                            SizedBox(
                              height: media.width * 0.04,
                            ),
                            OutlinedTextField(
                              hitText: 'Description',
                              icon: const Icon(Icons.description),
                              controller: descriptionController,
                              maxLines: 3,
                            ),
                            SizedBox(
                              height: media.width * 0.04,
                            ),
                            OutlinedTextField(
                              hitText: 'No Of Exercises Per Set',
                              icon: const Icon(Icons.numbers),
                              controller: noOfExercisePerSetController,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(
                              height: media.width * 0.04,
                            ),
                            InkWell(
                              onTap: () => handleImageUpload(),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: TColor.gray.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.attach_file,
                                      color: TColor.gray,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        imageFile != null
                                            ? imageFile!.path.split('/').last
                                            : 'Upload Image',
                                        style: TextStyle(color: TColor.gray),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (imageFile != null)
                                      Flexible(
                                        child: Image.file(
                                          imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.04,
                            ),
                            SizedBox(
                              height: media.height * 0.4,
                              child: ListView.builder(
                                itemCount: selectedExercises.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == selectedExercises.length) {
                                    return _buildAddExerciseButton();
                                  }
                                  return _buildExerciseItem(index);
                                },
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.01,
                            ),
                            RoundButton(
                              onPressed: () {
                                List<int> exercisesList =
                                    selectedExercises.values.toList();
                                List<IntPair> exercisesPair = selectedExercises
                                    .entries
                                    .map((entry) =>
                                        IntPair(entry.key, entry.value))
                                    .toList();
                                var body = {
                                  'name': nameController.text.trim(),
                                  'slug': slugController.text.trim(),
                                  'description':
                                      descriptionController.text.trim(),
                                  'exercises': exercisesList,
                                  'count': exercisesList.length,
                                  'no_of_ex_per_set':
                                      noOfExercisePerSetController.text.trim()
                                };
                                save(body);
                              },
                              title: 'Save',
                            ),
                            SizedBox(
                              height: media.width * 0.01,
                            ),
                          ],
                        )
                      : const SizedBox()),
            ),
          );
  }

  Widget _buildAddExerciseButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        setState(() {
          selectedExercises[selectedExercises.length] = exercises.first.id;
        });
      },
    );
  }

  Widget _buildExerciseItem(int index) {
    final selectedExerciseId = selectedExercises[index] ??
        0; // Provide a default value if the index is not found
    return ListTile(
      title: DropdownButton<int>(
        value: selectedExerciseId,
        onChanged: (newValue) {
          setState(() {
            selectedExercises[index] = newValue!;
          });
        },
        items: exercises
            .map<DropdownMenuItem<int>>((exercise) => DropdownMenuItem<int>(
                  value: exercise.id,
                  child: Text(
                    exercise.name,
                    style: const TextStyle(fontSize: 11),
                  ),
                ))
            .toList(),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          setState(() {
            selectedExercises.remove(index);
          });
        },
      ),
    );
  }
}

class IntPair {
  final int key;
  final int value;

  IntPair(this.key, this.value);

  @override
  String toString() {
    return '$key: $value';
  }
}

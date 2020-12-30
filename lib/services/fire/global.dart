import 'package:goaltracker/models/goal.dart';
import 'package:goaltracker/models/profile.dart';
import 'package:goaltracker/models/wall_fire.dart';
import 'package:goaltracker/services/fire/database.dart';

class Global {
  static final Map models = {
    Goal: (data) => Goal.fromMap(data),
    WallFire: (data) => WallFire.fromMap(data),
    // Service: (data) => Service.fromMap(data),
    Profile: (data) => Profile.fromMap(data),
    // Review: (data) => Review.fromMap(data),
    // Appointment: (data) => Appointment.fromMap(data)
  };

  // static final Collection<Salon> salonRef = Collection<Salon>(path: "salon");

  // static final Collection<Appointment> appointRef =
  //     Collection<Appointment>(path: "appointments");
  static final UserData<Profile> profileRef =
      UserData<Profile>(collection: "profiles");
  static final Collection<Goal> goalsRef = Collection<Goal>(path: "goals");
  static final Collection<WallFire> wallfireRef =
      Collection<WallFire>(path: "wallfire");
}

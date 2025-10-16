part of weather_app;

class UserAddressCubit extends Cubit<UserAddressState> {
  UserAddressCubit() : super(const UserAddressState());

  void setCity(String city) {
    emit(state.updateCityNames(city));
  }

  void setStreet(String street) {
    emit(state.updateStreetNames(street));
  }

  void setZipCode(String zipcode) {
    emit(state.copyWith(zipcode: zipcode));
  }
}

part of weather_app;

class UserAddressState extends Equatable {
  final String? city;
  final String? street;
  final String? zipcode;

  const UserAddressState({
    this.city,
    this.street,
    this.zipcode,
  });

  UserAddressState copyWith({
    String? city,
    String? street,
    String? zipcode,
  }) {
    return UserAddressState(
      city: city ?? this.city,
      street: street ?? this.street,
      zipcode: zipcode ?? this.zipcode,
    );
  }

  bool get isValid {
    return city != null && street != null && zipcode != null;
  }

  UserAddressState updateCityNames(String cityNameValue) {
    return UserAddressState(
      city: cityNameValue,
      street: null,
      zipcode: null,
    );
  }

  UserAddressState updateStreetNames(String streetNameValue) {
    return UserAddressState(
      city: city,
      street: streetNameValue,
      zipcode: null,
    );
  }

  String get cityName {
    return city ?? '';
  }

  String get streetName {
    return street ?? '';
  }

  String get zipCode {
    return zipcode ?? '';
  }

  @override
  List<Object?> get props => [
        city,
        street,
        zipcode,
      ];
}

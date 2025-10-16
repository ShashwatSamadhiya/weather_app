part of weather_app;

class UserAddressPage extends StatelessWidget {
  const UserAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Address')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<UserAddressCubit, UserAddressState>(
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'City'),
                  onChanged: (value) =>
                      context.read<UserAddressCubit>().setCity(value),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Street'),
                  onChanged: (value) =>
                      context.read<UserAddressCubit>().setStreet(value),
                  enabled: state.city != null &&
                      state.city!
                          .isNotEmpty, //, // only enable if city is selected
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Zipcode'),
                  onChanged: (value) =>
                      context.read<UserAddressCubit>().setZipCode(value),
                  enabled: state.street != null &&
                      state.street!
                          .isNotEmpty, // only enable if street is selected
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.isValid
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Profile submitted successfully!')),
                          );
                        }
                      : null,
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

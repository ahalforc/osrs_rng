# osrs_rng

A simple flutter-for-web project for doing random things for Old School RuneScape.

## Getting Started

To use the web-version of this app, visit: todo

## Contributing

This is still in its infancy.

To further expand on this, we'll need to add GoRouter with a NavigationRail to paginate between the tools.

### Building

To build the deployment code, run the following

```
flutter build web
rm -r app/
mkdir app/
cp -R build/web/ app/
```

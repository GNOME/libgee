namespace Gee {
	namespace Utils {
		namespace Async {
			[CCode (cheader_filename = "async.h")]
			public async void yield_and_unlock (GLib.Mutex mutex);
		}
	}
}

#include <iostream>
#include <conio.h>
#include <windows.h>
#include <algorithm>

using namespace std;

extern "C" int mandelbrot(char *b, int w, int h);

int main() {
	int width = 0, height = 0;

//	HWND okno = ::CreateWindowA("STATIC", "Zbior Mandelbrota", WS_VISIBLE, 0, 0, 0, 0, HWND_DESKTOP, NULL, GetModuleHandle(NULL), NULL);

	while (1) {
		cout << "Podaj szerokosc:" << endl;
		cin >> width;
		cout << "Podaj wysokosc:" << endl;
		cin >> height;

		int size = width * height;
		if (size == 0) {
			cout << "Podaj wartosci wysokosci i szerokosci wieksze od 0." << endl;
			continue;
		}
		char* buf = new char[size];
		for (int i = 0; i < size; i++)
			buf[i] = 0;


		mandelbrot(buf, width, height);

		HWND okno = ::CreateWindowA("STATIC", "", WS_VISIBLE, 0, 0, width, height, HWND_DESKTOP, NULL, GetModuleHandle(NULL), NULL);
		HDC hdc = GetDC(okno);
		/*for (int i = 0; i < size; i++) {
			int x = i % width, y = i / width;
			if(buf[i] != 0)
				SetPixel(hdc, y, x, RGB(0, 0, 0));
		}*/
		for (int i = 0; i < width; i++) 
			for (int j = 0; j < height; j++)
				if (buf[j*width + i] != 0)
						SetPixel(hdc, j, i, RGB(0, 0, 0));

		_getch();
		PostMessage(okno, WM_CLOSE, 0, 0);
		DestroyWindow(okno);
	}
	
	return 0;
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;

namespace RAWRFileManager
{
	/// <summary>
	/// Interaction logic for MainWindow.xaml
	/// </summary>
	public partial class MainWindow : Window
	{

		// Private stuff
		FormatRAWRProgress pgFormatRAWR;

		public MainWindow()
		{
			InitializeComponent();
		}

		private void Window_Loaded(object sender, RoutedEventArgs e)
		{
			pgFormatRAWR = new FormatRAWRProgress();
		}

		private void NewRAWRItem_Click(object sender, RoutedEventArgs e)
		{
			// Open a file chooser to choose where to put the RAWR system
			Microsoft.Win32.SaveFileDialog dlg = new Microsoft.Win32.SaveFileDialog();
			dlg.FileName = "RAWR";
			dlg.DefaultExt = ".img";
			dlg.Filter = "Virtual Image Files (.img)|*.img";
			dlg.Title = "Create New RAWR Virtual Disc";

			// Show file chooser
			Nullable<bool> result = dlg.ShowDialog();

			// Format the RAWR system on selected filename if selected
			if (result == true)
			{
				// Show my progress window of formatting my RAWR filesystem
				pgFormatRAWR.Show();

				// Start creation of my file
				BinaryWriter bw = new BinaryWriter(File.Open(dlg.FileName, FileMode.Create));

				// Create my RAWR header
				string rawrLabel = "RAWR File System";
				byte majorVersion = 0;
				byte minorVersion = 5;
				uint lastAccessTime = 4294967295; // just a random number for now, all 1's in binary
				uint sectorSize = 512; // typical sector size, in bytes
				uint sizeFileSystem = 102400; // number of sectors, 50 MB
				uint blockSize = (sizeFileSystem - 1) / 256; // in sectors, allow 256 blocks. Excludes RAWR Header.
				uint memoryUnitSize = ((blockSize - 1)* sectorSize) / 1024; // in bytes, allowing 1024 memory units in each block

				// Set my minimum and maximum values here
				pgFormatRAWR.FormatProgressBar.Minimum = 0;
				pgFormatRAWR.FormatProgressBar.Maximum = sizeFileSystem;
				pgFormatRAWR.FormatProgressBar.Value = 0;

				// Write values to file
				bw.Write(Encoding.ASCII.GetBytes(rawrLabel)); // have to use this method or else it writes string length before string, which I don't want
				bw.Write(majorVersion);
				bw.Write(minorVersion);
				bw.Write(lastAccessTime);
				bw.Write(sectorSize);
				bw.Write(sizeFileSystem);
				bw.Write(blockSize);
				bw.Write(memoryUnitSize);

				// Create 0's to fill up the sector
				byte zero = 0;
				while (bw.BaseStream.Position < sectorSize)
				{
					bw.Write(zero);
				}


				// Now define my block header which I will copy everywhere I need to put one
				string blockLabel = "BLCK";
				uint memoryUnits = ((blockSize - 1) * sectorSize) / memoryUnitSize;
				uint memoryUnitsBytes = 0;

				if ((memoryUnits % 8) == 0)
				{
					memoryUnitsBytes = memoryUnits / 8;
				}
				else
				{
					memoryUnitsBytes = (memoryUnits / 8) + 1;
				}


				byte[] memBitmap = new byte[memoryUnitsBytes];

				for (int i = 0; i < memoryUnitsBytes; i++)
				{
					memBitmap[i] = 0xFF;
				}


				// Update text saying that I am applying blocks throughout file system
				pgFormatRAWR.FormatLabel.Content = "Writing block headers...";

				// Copy my block header throughout file system
				uint x = 1; // in sectors
				while (x < sizeFileSystem)
				{
					bw.Write(Encoding.ASCII.GetBytes(blockLabel));
					bw.Write(memBitmap);

					// Fill rest of sector with 0's
					for (int i = 0; i < (sectorSize - memBitmap.Length - 4); i++)
					{
						bw.Write(zero);
					}

					// Fill rest of block partition with 0's
					for (int i = 0; i < ((blockSize - 1) * sectorSize); i++)
					{
						bw.Write(zero);
					}

					Debug.Print("Finished block");
					Debug.Print(x.ToString());
					Debug.Print(sizeFileSystem.ToString());

					x += blockSize;

					pgFormatRAWR.FormatProgressBar.Value = x;
				}

				// After everything has been done, close the file
				Debug.Print("Done!");
				bw.Close();

				// Close the progress thingy
				pgFormatRAWR.Close();
			}
		}

		private void Window_Closed(object sender, EventArgs e)
		{
			Environment.Exit(0);
		}
	}
	
	//
	// All of my possible memory units and the classes to represent them
	//
	public class DirectoryUnit
	{
		public string Name { get; set; }
		public CompositeCollection Children { get; set; }

		public DirectoryUnit(string name)
		{
			Name = name;
		}
	}

	public class FileUnit
	{
		public string Name { get; set; }
		public int Size { get; set; }

		public FileUnit(string name, int size)
		{
			Name = name;
			Size = size;
		}
	}
}

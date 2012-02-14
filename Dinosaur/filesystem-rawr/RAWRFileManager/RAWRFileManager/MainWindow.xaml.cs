using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;
using System.ComponentModel;

namespace RAWRFileManager
{
	/// <summary>
	/// Interaction logic for MainWindow.xaml
	/// </summary>
	public partial class MainWindow : Window
	{

		// Progress Windows
		FormatRAWRProgress pgFormatRAWR;

		// File system data and manager
		RAWRManager manager;

		public MainWindow()
		{
			InitializeComponent();
		}

		private void Window_Loaded(object sender, RoutedEventArgs e)
		{
			pgFormatRAWR = new FormatRAWRProgress();
			manager = new RAWRManager("");
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

				// Create a BackgroundWorker that will create my RAWR file system
				BackgroundWorker rawrWriter = new BackgroundWorker();

				rawrWriter.DoWork += new DoWorkEventHandler(rawrWriter_DoWork);
				rawrWriter.ProgressChanged += new ProgressChangedEventHandler(rawrWriter_ProgressChanged);
				rawrWriter.RunWorkerCompleted += new RunWorkerCompletedEventHandler(rawrWriter_RunWorkerCompleted);

				rawrWriter.WorkerReportsProgress = true;
				rawrWriter.RunWorkerAsync(dlg.FileName); // Passing in my file name to the worker
			}
		}

		void rawrWriter_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
		{
			// Hide my progress window
			if (pgFormatRAWR.IsActive)
				pgFormatRAWR.Hide();

			// Make my newly created RAWR file my selected file

		}

		void rawrWriter_ProgressChanged(object sender, ProgressChangedEventArgs e)
		{
			// Update my RAWR progress bar depending on the change
			pgFormatRAWR.FormatProgressBar.Value = e.ProgressPercentage;
		}

		void rawrWriter_DoWork(object sender, DoWorkEventArgs e)
		{
			// Cast my sender as a BackgroundWorker, since that is what it is
			BackgroundWorker s = (BackgroundWorker)sender;
			
			// Start creation of my file
			BinaryWriter bw = new BinaryWriter(File.Open((string)e.Argument, FileMode.Create));

			// Create my RAWR header
			string rawrLabel = "RAWR File System";
			byte majorVersion = 0;
			byte minorVersion = 5;
			uint lastAccessTime = 4294967295; // just a random number for now, all 1's in binary
			uint sectorSize = 512; // typical sector size, in bytes
			uint sizeFileSystem = 102400; // number of sectors, 50 MB
			uint blockSize = (sizeFileSystem - 1) / 256; // in sectors, allow 256 blocks. Excludes RAWR Header.
			uint memoryUnitSize = ((blockSize - 1) * sectorSize) / 1024; // in bytes, allowing 1024 memory units in each block

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

				x += blockSize;

				double percentage = ((double)x / (double)sizeFileSystem) * 100;

				s.ReportProgress((int)percentage);
			}

			// After everything has been done, close the file
			bw.Close();
		}

		private void Window_Closed(object sender, EventArgs e)
		{
			Environment.Exit(0);
		}
	}
	
	
}

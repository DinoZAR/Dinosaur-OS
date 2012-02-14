using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Data;
using System.IO;

namespace RAWRFileManager
{
	/// <summary>
	/// The RAWRManager is responsible for retrieving data from the virtual RAWR disc it is assigned to. The UI will use its functions to obtain data from it.
	/// </summary>
	public class RAWRManager
	{
		public string RAWRFile { get; set; }

		public RAWRManager(string rawrFile)
		{
			RAWRFile = rawrFile;
		}

		/*
		 * Data accessors
		 */
		public MemoryUnit Get(string absPath)
		{
			return null;
		}

		public MemoryUnit[] ReadDirectory(DirectoryUnit directory)
		{
			return null;
		}


		/*
		 * Adders, deleters, and changers
		 */
		/// <summary>
		/// Adds the file given in absPath to the RAWR filesystem using the data in "f".
		/// 
		/// Example:
		/// To add a text file called YourMom.txt to /home/your/mom/, you would issue the following:
		/// .Add({your file from your file system called YourMom.txt}, "/home/your/mom/YourMom.txt");
		/// </summary>
		/// <param name="f">File containing the data to write into the file system.</param>
		/// <param name="absPath">The complete path, including the file name and extension, into the file system to save the file.</param>
		/// <returns></returns>
		public bool Add(File f, string absPath)
		{
			return false;
		}

		public bool Delete(string absPath)
		{
			return false;
		}

		public bool Rename(string absPath, string newName)
		{
			return false;
		}

		public bool Move(string absPath, string absPathNewRoot)
		{
			return false;
		}
	}


	/*
	 * Classes that encapsulate data retrieved from RAWR memory units
	 */
	public enum MemUnitType {File, Continuation, Directory, Link};

	public class MemoryUnit
	{
		public MemUnitType Type {get;}
		public string Name { get; set; }

	}

	public class DirectoryUnit : MemoryUnit
	{
		public CompositeCollection Children { get; set; }

		public DirectoryUnit(string name)
		{
			Name = name;
		}
	}

	public class FileUnit : MemoryUnit
	{
		public int Size { get; set; }

		public FileUnit(string name, int size)
		{
			Name = name;
			Size = size;
		}
	}

	public class LinkUnit : MemoryUnit
	{
		public uint Block { get; set; }
		public uint MemUnitAddress { get; set; }

		public LinkUnit(uint blockAddress, uint memUnitAddress)
		{
			Block = blockAddress;
			MemUnitAddress = memUnitAddress;
		}

	}
}

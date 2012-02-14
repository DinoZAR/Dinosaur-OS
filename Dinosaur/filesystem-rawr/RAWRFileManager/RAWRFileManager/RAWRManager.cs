using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Data;

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


		public MemoryUnit Get(string absPath)
		{
			return null;
		}

		public MemoryUnit[] ReadDirectory(DirectoryUnit directory)
		{
			return null;
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

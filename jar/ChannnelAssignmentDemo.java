/* Necessary package imports */
import com.mathworks.toolbox.javabuilder.*;
import wi5.*;

public class ChannnelAssignmentDemo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
        double[][] pathLoss =  {{0, 43.8942, 42.3555, 68.2704},
                                {43.8804, 0, 39.9005, 44.4645},
                                {43.5166, 38.2524, 0, 48.0190},
                                {44.1848, 43.9005, 44.1896, 0}};
        
        get_channel_assignments(pathLoss, ChSelectionAlgorithm.WI5);
        tryAllChannelAssignmentMethods(pathLoss);


        System.exit(0);
    }
	
	private static void get_channel_assignments(double[][] pathLosses, ChSelectionAlgorithm methodType) {
		  
		  System.out.println(System.getProperty("java.library.path"));

	    MWNumericArray n = null;   /* Stores method_number */
	    Object[] result = null;    /* Stores the result */
	    Wi5 channelFinder= null;     /* Stores magic class instance */

	    MWNumericArray pathLossMatrix = null;

	    try
	    {
	        /* Convert and print inputs */

	        pathLossMatrix = new MWNumericArray(pathLosses, MWClassID.DOUBLE);
	        n = new MWNumericArray(methodType.getValue(), MWClassID.DOUBLE);

	     /* Create new ChannelAssignment object */

	        channelFinder = new Wi5();

	        result = channelFinder.getChannelAssignments(1, pathLossMatrix, n);

	     /* Compute magic square and print result */
	        System.out.println("============CHANNEL ASSIGNMENTS=============");
	        System.out.println(result[0]);
	        System.out.println("============================================");
	    }
	    catch (Exception e)
	    {
	        System.out.println("Exception: " + e.toString());
	    }

	    finally
	    {
	     /* Free native resources */
	        MWArray.disposeArray(pathLossMatrix);
	        MWArray.disposeArray(result);
	        if (channelFinder != null)
	            channelFinder.dispose();
	    }

	}
	
	private static void tryAllChannelAssignmentMethods(double[][] pathLosses) {
		  
		  System.out.println(System.getProperty("java.library.path"));

	    MWNumericArray n = null;   /* Stores method_number */
	    Object[] result = null;    /* Stores the result */
	    Wi5 channelFinder= null;     /* Stores magic class instance */

	    MWNumericArray pathLossMatrix = null;

	    try
	    {
	        /* Convert and print inputs */

	        pathLossMatrix = new MWNumericArray(pathLosses, MWClassID.DOUBLE);
	        channelFinder = new Wi5();
	        
	        for(ChSelectionAlgorithm methodType:ChSelectionAlgorithm.values()) {
	        	
	        	n = new MWNumericArray(methodType.getValue(), MWClassID.DOUBLE);

	        	/* Create new ChannelAssignment object */

	        

	        	result = channelFinder.getChannelAssignments(1, pathLossMatrix, n);

	        	/* Compute magic square and print result */
		        System.out.println("============CHANNEL ASSIGNMENTS=============");
		        System.out.println("METHOD: " + methodType.name());
		        System.out.println(result[0]);
		        System.out.println("============================================");
	        }
	    }
	    catch (Exception e)
	    {
	        System.out.println("Exception: " + e.toString());
	    }

	    finally
	    {
	     /* Free native resources */
	        MWArray.disposeArray(pathLossMatrix);
	        MWArray.disposeArray(result);
	        if (channelFinder != null)
	            channelFinder.dispose();
	    }

	}

		private enum ChSelectionAlgorithm{
			WI5(1), RANDOM(2), LCC(3);
			
			private final int value;    

			private ChSelectionAlgorithm(int value) {
				this.value = value;
			}
			
			public int getValue() {
				return this.value;
			}
		}
}


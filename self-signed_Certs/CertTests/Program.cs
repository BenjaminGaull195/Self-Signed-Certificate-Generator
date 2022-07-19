using System;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.IO;

class TestX509Chain
{
    static void Main(string[] args)
    {
       
        X509Certificate2 certificate = new X509Certificate2("/home/pi/self-signed_Certs/server.crt");
        X509Certificate2 intermediate = new X509Certificate2("/home/pi/self-signed_Certs/intermediate.crt");
        X509Certificate2 root = new X509Certificate2("/home/pi/self-signed_Certs/root.crt");

        Console.WriteLine("{0} {1}", root.ToString(true), Environment.NewLine);
        Console.WriteLine("{0} {1}", intermediate.ToString(true), Environment.NewLine);
        Console.WriteLine("{0} {1}", certificate.ToString(true), Environment.NewLine);

        //Output chain information of the selected certificate.
        X509Chain ch = new X509Chain();
        ch.ChainPolicy.TrustMode = X509ChainTrustMode.CustomRootTrust;
        ch.ChainPolicy.CustomTrustStore.Add(new X509Certificate2("/home/pi/self-signed_Certs/root.crt"));
        ch.ChainPolicy.CustomTrustStore.Add(new X509Certificate2("/home/pi/self-signed_Certs/intermediate.crt"));
        ch.ChainPolicy.RevocationMode = X509RevocationMode.NoCheck;
        Console.WriteLine ("Chain Validation: {0}", ch.Build (certificate));
        Console.WriteLine ("Chain Information");
        Console.WriteLine ("Chain revocation flag: {0}", ch.ChainPolicy.RevocationFlag);
        Console.WriteLine ("Chain revocation mode: {0}", ch.ChainPolicy.RevocationMode);
        Console.WriteLine ("Chain verification flag: {0}", ch.ChainPolicy.VerificationFlags);
        Console.WriteLine ("Chain verification time: {0}", ch.ChainPolicy.VerificationTime);
        Console.WriteLine ("Chain status length: {0}", ch.ChainStatus.Length);
        Console.WriteLine ("Chain application policy count: {0}", ch.ChainPolicy.ApplicationPolicy.Count);
        Console.WriteLine ("Chain certificate policy count: {0} {1}", ch.ChainPolicy.CertificatePolicy.Count, Environment.NewLine);

        //Output chain element information.
        Console.WriteLine ("Chain Element Information");
        Console.WriteLine ("Number of chain elements: {0}", ch.ChainElements.Count);
        Console.WriteLine ("Chain elements synchronized? {0} {1}", ch.ChainElements.IsSynchronized, Environment.NewLine);
    
        foreach (X509ChainElement element in ch.ChainElements)
        {
            Console.WriteLine ("Element issuer name: {0}", element.Certificate.Issuer);
            Console.WriteLine ("Element certificate valid until: {0}", element.Certificate.NotAfter);
            Console.WriteLine ("Element certificate is valid: {0}", element.Certificate.Verify());
            Console.WriteLine ("Element error status length: {0}", element.ChainElementStatus.Length);
            Console.WriteLine ("Element information: {0}", element.Information);
            Console.WriteLine ("Number of element extensions: {0}{1}", element.Certificate.Extensions.Count, Environment.NewLine);

            if (ch.ChainStatus.Length > 1)
            {
                for (int index = 0; index < element.ChainElementStatus.Length; index++)
                {
                    Console.WriteLine (element.ChainElementStatus[index].Status);
                    Console.WriteLine (element.ChainElementStatus[index].StatusInformation);
                }
            }
        }

        if (certificate.Verify()) {
            Console.WriteLine("Certificate {0} verified", certificate.Subject);
        }
        else {
            Console.WriteLine("Certificate {0} failed", certificate.Subject);
        }
    }
}
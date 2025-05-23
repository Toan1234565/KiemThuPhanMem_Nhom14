using NUnit.Framework;
using System.Net;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;
using GOATBOOKING.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Testing; // Quan trọng: Thêm using này
using Microsoft.Extensions.DependencyInjection.Extensions; // Quan trọng: Thêm using này
using Microsoft.AspNetCore.Hosting; // Quan trọng: Thêm using này

[TestFixture]
public class HomestaysControllerApiTests
{
    // Khai báo WebApplicationFactory trực tiếp trong lớp test
    private WebApplicationFactory<Program> _factory;
    private HttpClient _client;

    [SetUp]
    public void Setup()
    {
        _factory = new WebApplicationFactory<Program>()
            .WithWebHostBuilder(builder =>
            {
                builder.UseEnvironment("Development");

                builder.ConfigureServices(services =>
                {
                    // Xóa các đăng ký DbContext để tránh xung đột
                    services.RemoveAll<MasterContext>();
                    services.RemoveAll<DbContextOptions<MasterContext>>();

                    // Đăng ký DbContext sử dụng SQL Server mà không xóa database
                    services.AddDbContext<MasterContext>(options =>
                        options.UseSqlServer("Data Source=TOAN;Initial Catalog=GOATBOOKING1;Integrated Security=True;Trust Server Certificate=True;"));

                    var serviceProvider = services.BuildServiceProvider();

                    using (var scope = serviceProvider.CreateScope())
                    {
                        var dbContext = scope.ServiceProvider.GetRequiredService<MasterContext>();

                        // Chỉ đảm bảo rằng database đã tồn tại, không xóa
                        if (!dbContext.Database.CanConnect())
                        {
                            Console.WriteLine("❌ Không thể kết nối đến database!");
                        }
                        else
                        {
                            Console.WriteLine("✅ Kết nối thành công đến database hiện tại.");
                        }
                    }
                });
            });

        _client = _factory.CreateClient();
    }

    [TearDown]
    public void TearDown()
    {
        _client?.Dispose();
        _factory?.Dispose();
    }

   

    // Chi tiết các Test Case

    // TC01: Thêm mới Homestay thành công
    [Test]
    [Description("TC01_API: Gửi yêu cầu POST thành công để thêm mới Homestay với dữ liệu hợp lệ")]
    public async Task TC01_PostHomestay_ValidData_ReturnsCreated()
    {
        long newHomestayId = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
        var newHomestay = new Homestay
        {
            HomestayId = newHomestayId,
            Name = "Homestay API Test Success",
            Description = "Mô tả cho homestay test API thành công.",
            Ward = "Phường API",
            District = "Quận API",
            Province = "Tỉnh API",
            UserId = 1
        };

        Console.WriteLine("Đang gửi yêu cầu POST để tạo Homestay...");

        // Chú ý: Sử dụng base address của ứng dụng hoặc đường dẫn tương đối
        // Nếu bạn chạy API trên một cổng cụ thể, hãy cấu hình base address cho _client
        // hoặc dùng đường dẫn tương đối như "/api/Homestays"
        var response = await _client.PostAsJsonAsync("https://localhost:7246/api/Homestays", newHomestay);

        Console.WriteLine($"Phản hồi từ API: {response.StatusCode}");
        Console.WriteLine($"Nội dung phản hồi: {await response.Content.ReadAsStringAsync()}");

        Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.Created),
            $"Test thất bại! Expected status code 201 Created, but got {response.StatusCode}");

        var createdHomestay = await response.Content.ReadFromJsonAsync<Homestay>();

        Assert.That(createdHomestay, Is.Not.Null, "Returned Homestay object should not be null.");
        Assert.That(createdHomestay.HomestayId, Is.EqualTo(newHomestay.HomestayId), " HomestayId should match.");
        Assert.That(createdHomestay.Name, Is.EqualTo(newHomestay.Name), " Name should match.");
        Assert.That(createdHomestay.CreatedAt, Is.GreaterThan(0), " CreatedAt should be set.");
        Assert.That(createdHomestay.UpdatedAt, Is.GreaterThan(0), " UpdatedAt should be set.");

        using (var scope = _factory.Services.CreateScope())
        {
            var dbContext = scope.ServiceProvider.GetRequiredService<MasterContext>();
            var retrievedHomestay = await dbContext.Homestays.FindAsync(newHomestayId);

            Console.WriteLine($" Kiểm tra trong database: Homestay có tồn tại không? {(retrievedHomestay != null ? " Có" : " Không có")}");

            Assert.That(retrievedHomestay, Is.Not.Null, " Homestay should be found in the database.");
            Assert.That(retrievedHomestay.Name, Is.EqualTo(newHomestay.Name), " Retrieved homestay name should match.");
        }

        Console.WriteLine("Test TC01 hoàn thành!");
    }


    // TC02: Thêm Homestay với ID đã tồn tại (dẫn đến Conflict)
    [Test]
    [Description("TC02_API: Gửi yêu cầu POST thất bại khi thêm Homestay với ID đã tồn tại.")]
    public async Task TC02_PostHomestay_ExistingId_ReturnsConflict()
    {
        long existingHomestayId = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() + 1;
        var homestayToCreate = new Homestay
        {
            HomestayId = existingHomestayId,
            Name = "Homestay First Existing",
            Description = "Initial creation for conflict test",
            Ward = "Ward X",
            District = "District Y",
            Province = "Province Z",
            UserId = 0
        };

        Console.WriteLine(" Đang tạo Homestay ban đầu để kiểm tra ID trùng lặp...");
        var initialResponse = await _client.PostAsJsonAsync("https://localhost:7246/api/Homestays", homestayToCreate);
        initialResponse.EnsureSuccessStatusCode();
        Console.WriteLine(" Homestay ban đầu đã được tạo thành công.");

        var duplicateHomestay = new Homestay
        {
            HomestayId = existingHomestayId, // ID trùng lặp
            Name = "Homestay API Duplicate",
            Description = "Mô tả cho homestay test API trùng ID.",
            Ward = "Phường Trùng",
            District = "Quận Lặp",
            Province = "Tỉnh Lỗi",
            UserId = 0
        };

        Console.WriteLine(" Đang gửi yêu cầu POST với ID trùng...");
        var response = await _client.PostAsJsonAsync("https://localhost:7246/api/Homestays", duplicateHomestay);
        Console.WriteLine($" Phản hồi từ API: {response.StatusCode}");

        Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.Conflict),
            $"Expected status code 409 Conflict, but got {response.StatusCode}. Response: {await response.Content.ReadAsStringAsync()}");

        var errorMessage = await response.Content.ReadAsStringAsync();
        Assert.That(errorMessage, Is.EqualTo("Id homestay đã tồn tại"), "Thông báo lỗi phải cho biết ID hiện có.");

        Console.WriteLine("Kiểm thử TC02 hoàn tất! Homestay với ID trùng đã bị từ chối.");
    }




    // TC03: Thêm Homestay với Name null (dẫn đến Bad Request)
    [Test]
    [Description("TC03_API: Gửi yêu cầu POST thất bại khi thêm Homestay với Model không hợp lệ (ví dụ: thiếu Name).")]
    public async Task TC03_PostHomestay_InvalidModelState_ReturnsBadRequest()
    {
        var invalidHomestay = new Homestay
        {
            HomestayId = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
            Name = null, // Thiếu trường Name
            Description = "Mô tả homestay không hợp lệ.",
            Ward = "Invalid Ward",
            District = "Invalid District",
            Province = "Invalid Province",
            UserId = 0
        };

        Console.WriteLine(" Đang gửi yêu cầu POST để tạo Homestay với Name null...");

        var response = await _client.PostAsJsonAsync("https://localhost:7246/api/Homestays", invalidHomestay);
        Console.WriteLine($" Phản hồi từ API: {response.StatusCode}");

        Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.BadRequest),
            $" Expected status code 400 Bad Request, but got {response.StatusCode}. Response: {await response.Content.ReadAsStringAsync()}");

        var responseBody = await response.Content.ReadAsStringAsync();
        Console.WriteLine($" Nội dung phản hồi API: {responseBody}");

        var problemDetails = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.That(problemDetails, Is.Not.Null, " ProblemDetails should not be null.");

        Assert.That(problemDetails.Errors.ContainsKey("Name"), " Error details should contain 'Name' field error.");
        Assert.That(problemDetails.Errors["Name"].Contains("Tên homestay là bắt buộc"), " Error message for Name should be correct.");

        Console.WriteLine(" Kiểm thử TC03 hoàn tất! API đã từ chối Homestay với Name null.");
    }




    [Test]
    [Description("TC04_API: Gửi yêu cầu POST thất bại khi thêm Homestay với Description rỗng.")]
    public async Task TC04_PostHomestay_EmptyDescription_ReturnsBadRequest()
    {
        var invalidHomestay = new Homestay
        {
            HomestayId = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
            Name = "Homestay Valid Name",
            Description = "", // Description rỗng
            Ward = "Ward Test",
            District = "District Test",
            Province = "Province Test",
            UserId = 0
        };

        Console.WriteLine(" Đang gửi yêu cầu POST để tạo Homestay với Description rỗng...");
        var response = await _client.PostAsJsonAsync("https://localhost:7246/api/Homestays", invalidHomestay);
        Console.WriteLine($" Phản hồi từ API: {response.StatusCode}");

        Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.BadRequest),
            $" Expected status code 400 Bad Request, but got {response.StatusCode}. Response: {await response.Content.ReadAsStringAsync()}");

        var responseBody = await response.Content.ReadAsStringAsync();
        Console.WriteLine($" Nội dung phản hồi API: {responseBody}");

        var problemDetails = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.That(problemDetails.Errors.ContainsKey("Description"), " Error details should contain 'Description' field error.");
        Assert.That(problemDetails.Errors["Description"].Contains("Mô tả homestay là bắt buộc"), " Error message for Description should be correct.");

        Console.WriteLine(" Kiểm thử TC04 hoàn tất! API đã từ chối Homestay với Description rỗng.");
    }
    [Test]
    [Description("TC05_API: Gửi yêu cầu POST thất bại khi thêm Homestay với Ward rỗng.")]
    public async Task TC05_PostHomestay_EmptyWard_ReturnsBadRequest()
    {
        var invalidHomestay = new Homestay
        {
            HomestayId = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
            Name = "Homestay Valid Name",
            Description = "Valid description",
            Ward = "", // Ward rỗng
            District = "District Test",
            Province = "Province Test",
            UserId = 0
        };

        Console.WriteLine(" Đang gửi yêu cầu POST để tạo Homestay với Ward rỗng...");
        var response = await _client.PostAsJsonAsync("https://localhost:7246/api/Homestays", invalidHomestay);
        Console.WriteLine($" Phản hồi từ API: {response.StatusCode}");

        Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.BadRequest),
            $"❌ Expected status code 400 Bad Request, but got {response.StatusCode}. Response: {await response.Content.ReadAsStringAsync()}");

        var responseBody = await response.Content.ReadAsStringAsync();
        Console.WriteLine($" Nội dung phản hồi API: {responseBody}");

        var problemDetails = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.That(problemDetails.Errors.ContainsKey("Ward"), " Error details should contain 'Ward' field error.");
        Assert.That(problemDetails.Errors["Ward"].Contains("Phường/xã là bắt buộc"), " Error message for Ward should be correct.");

        Console.WriteLine(" Kiểm thử TC05 hoàn tất! API đã từ chối Homestay với Ward rỗng.");
    }
    [Test]
    [Description("TC06_API: Gửi yêu cầu POST thất bại khi thêm Homestay với District rỗng.")]
    public async Task TC06_PostHomestay_EmptyDistrict_ReturnsBadRequest()
    {
        var invalidHomestay = new Homestay
        {
            HomestayId = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
            Name = "Homestay Valid Name",
            Description = "Valid description",
            Ward = "Ward Test",
            District = "", // District rỗng
            Province = "Province Test",
            UserId = 0
        };

        Console.WriteLine(" Đang gửi yêu cầu POST để tạo Homestay với District rỗng...");
        var response = await _client.PostAsJsonAsync("https://localhost:7246/api/Homestays", invalidHomestay);
        Console.WriteLine($" Phản hồi từ API: {response.StatusCode}");

        Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.BadRequest),
            $" Expected status code 400 Bad Request, but got {response.StatusCode}. Response: {await response.Content.ReadAsStringAsync()}");

        var responseBody = await response.Content.ReadAsStringAsync();
        Console.WriteLine($" Nội dung phản hồi API: {responseBody}");

        var problemDetails = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.That(problemDetails.Errors.ContainsKey("District"), " Error details should contain 'District' field error.");
        Assert.That(problemDetails.Errors["District"].Contains("Quận/Huyện là bắt buộc"), " Error message for District should be correct.");

        Console.WriteLine("Kiểm thử TC06 hoàn tất! API đã từ chối Homestay với District rỗng.");
    }




    // TC07: Thêm Homestay với Province rỗng (dẫn đến Bad Request)
    [Test]
    [Description("TC07_API: Gửi yêu cầu POST thất bại khi thêm Homestay với Province rỗng.")]
    public async Task TC07_PostHomestay_EmptyProvince_ReturnsBadRequest()
    {
        var invalidHomestay = new Homestay
        {
            HomestayId = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
            Name = "Homestay Valid Name",
            Description = "Valid description",
            Ward = "Ward Test",
            District = "District Test",
            Province = "", // Province rỗng
            UserId = 0
        };

        Console.WriteLine("Đang gửi yêu cầu POST để tạo Homestay với Province rỗng...");

        var response = await _client.PostAsJsonAsync("https://localhost:7246/api/Homestays", invalidHomestay);
        Console.WriteLine($"Phản hồi từ API: {response.StatusCode}");

        Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.BadRequest),
            $"Expected status code 400 Bad Request, but got {response.StatusCode}. Response: {await response.Content.ReadAsStringAsync()}");

        var responseBody = await response.Content.ReadAsStringAsync();
        Console.WriteLine($" Nội dung phản hồi API: {responseBody}");

        var problemDetails = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.That(problemDetails, Is.Not.Null, " ProblemDetails should not be null.");

        Assert.That(problemDetails.Errors.ContainsKey("Province"), " Error details should contain 'Province' field error.");
        Assert.That(problemDetails.Errors["Province"].Contains("Tỉnh/Thành phố là bắt buộc"), "❌ Error message for Province should be correct.");

        Console.WriteLine("Kiểm thử TC07 hoàn tất! API đã từ chối Homestay với Province rỗng.");
    }



    // TC08: Thêm Homestay thiếu nhiều trường Required (dẫn đến Bad Request)
    [Test]
    [Description("TC08_API: Gửi yêu cầu POST thất bại khi thêm Homestay thiếu nhiều trường Required.")]
    public async Task TC08_PostHomestay_MissingMultipleRequiredFields_ReturnsBadRequest()
    {
        var invalidHomestay = new Homestay
        {
            HomestayId = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
            Name = null,
            Description = null,
            Ward = null,
            District = null,
            Province = null,
            UserId = 0
        };

        Console.WriteLine(" Đang gửi yêu cầu POST để tạo Homestay với nhiều trường bắt buộc bị thiếu...");

        var response = await _client.PostAsJsonAsync("https://localhost:7246/api/Homestays", invalidHomestay);
        Console.WriteLine($"Phản hồi từ API: {response.StatusCode}");

        Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.BadRequest),
            $"❌ Expected status code 400 Bad Request, but got {response.StatusCode}. Response: {await response.Content.ReadAsStringAsync()}");

        var responseBody = await response.Content.ReadAsStringAsync();
        Console.WriteLine($" Nội dung phản hồi API: {responseBody}");

        var problemDetails = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.That(problemDetails, Is.Not.Null, "ProblemDetails should not be null.");

        Assert.Multiple(() =>
        {
            Assert.That(problemDetails.Errors.ContainsKey("Name"), " Error details should contain 'Name' field error.");
            Assert.That(problemDetails.Errors["Name"].Contains("Tên homestay là bắt buộc"), " Error message for Name should be correct.");

            Assert.That(problemDetails.Errors.ContainsKey("Description"), " Error details should contain 'Description' field error.");
            Assert.That(problemDetails.Errors["Description"].Contains("Mô tả homestay là bắt buộc"), " Error message for Description should be correct.");

            Assert.That(problemDetails.Errors.ContainsKey("Ward"), " Error details should contain 'Ward' field error.");
            Assert.That(problemDetails.Errors["Ward"].Contains("Phường/xã là bắt buộc"), " Error message for Ward should be correct.");

            Assert.That(problemDetails.Errors.ContainsKey("District"), " Error details should contain 'District' field error.");
            Assert.That(problemDetails.Errors["District"].Contains("Quận/Huyện là bắt buộc"), " Error message for District should be correct.");


            Assert.That(problemDetails.Errors.ContainsKey("Province"), " Error details should contain 'Province' field error.");
            Assert.That(problemDetails.Errors["Province"].Contains("Tỉnh/Thành phố là bắt buộc"), " Error message for Province should be correct.");
        });

        Console.WriteLine("Kiểm thử TC08 hoàn tất! API đã từ chối Homestay với nhiều trường bắt buộc bị thiếu.");
    }

}
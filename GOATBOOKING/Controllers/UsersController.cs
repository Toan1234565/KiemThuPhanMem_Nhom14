using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GOATBOOKING.Models;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages.Manage;

namespace GOATBOOKING.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly MasterContext _context;

        public UsersController(MasterContext context)
        {
            _context = context;
        }

        // GET: api/Users
        [HttpGet] // lấy danh sách tất cả các bản ghi trong bảng
        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }

        // GET: api/Users/5
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(long id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

       

        [HttpGet("DangNhap")]
        public async Task<ActionResult<User>> GetDangNhap([FromQuery] string userName1, [FromQuery] string password)
        {
            // Tìm kiếm người dùng với username và password
            var user = await _context.Users
                .FirstOrDefaultAsync(i => i.UserName == userName1 && i.Password == password);

            if (user != null)
            {
                return Ok(); // Trả về thông tin người dùng nếu đăng nhập thành công
            }
            else
            {
                return BadRequest("Tên đăng nhập hoặc mật khẩu không đúng."); // Thông báo lỗi
            }
        }

        [HttpGet("getid_username")]
        public async Task<ActionResult<User>> GetId([FromQuery] string userName2)
        {
            var user = await _context.Users
                    .FirstOrDefaultAsync(i => i.UserName == userName2);

            if(user != null)
            {
                return user;
            }
            else
            {
                return NotFound();
            }
        }
        [HttpGet("getId")]
        public async Task<ActionResult<User>> GetUserId([FromQuery] int id, [FromQuery] string phoneNumber, [FromQuery] string email, [FromQuery] string userName)
        {
            var query = _context.Users.AsQueryable();

            // Kiểm tra UserId
            var userIdExists = await query.AnyAsync(i => i.UserId == id);

            // Kiểm tra PhoneNumber
            var phoneExists = await query.AnyAsync(i => i.PhoneNumber == phoneNumber);

            // Kiểm tra Email
            var emailExists = await query.AnyAsync(i => i.Email == email);

            // Kiểm tra UserName
            var userNameExists = await query.AnyAsync(i => i.UserName == userName);

            if (userIdExists)
            {
                return BadRequest("Id đã tồn tại");
            }
            if (phoneExists)
            {
                return BadRequest("Số điện thoại đã tồn tại");
            }
            if (emailExists)
            {
                return BadRequest("Email đã tồn tại");
            }
            if (userNameExists)
            {
                return BadRequest("Tên người dùng đã tồn tại");
            }

            return Ok();
        }

        [HttpGet("search")]
        public async Task<ActionResult<User>> GetUser([FromQuery] string search)
        {
            var query = _context.Users.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search))
            {
                query = query.Where(h => h.UserId.ToString().Contains(search) ||
                h.UserName.ToString().Contains(search) ||
                h.Email.ToString().Contains(search) ||
                h.PhoneNumber.ToString().Contains(search) ||
                h.Gender.ToString().Contains(search) ||
                h.FullName.ToString().Contains(search) ||
                h.CreatedAt.ToString().Contains(search) ||
                h.UpdatedAt.ToString().Contains(search));

            }
            var users = await query.ToListAsync();

            if (users == null || users.Count == 0)
            {
                return NotFound();
            }
            else
            {
                return Ok(users);
            }
        }
        //[HttpGet("getUserId")]
        //public async Task<ActionResult<User>> GetUserId()
        //{

        //}

        // PUT: api/Users/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(long id, User user)
        {
            if (id != user.UserId)
            {
                return BadRequest();
            }

            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }



        // POST: api/Users
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost] 
        public async Task<ActionResult<User>> PostUser(User user)
        {
            // Kiểm tra nếu UserId đã tồn tại trong cơ sở dữ liệu
            if (_context.Users.Any(u => u.UserId == user.UserId))
            {
                return Conflict("UserId đã tồn tại.");
            }

            // Đảm bảo các thuộc tính khác đã được gán đúng
            // cũ
            user.CreatedAt = GetFormattedDateAsLong();
            user.UpdatedAt = user.CreatedAt;

            // Thêm vào cơ sở dữ liệu
            _context.Users.Add(user);

            try
            {
                await _context.SaveChangesAsync();  // Lưu vào DB
            }
            catch (DbUpdateException)
            {
                // Nếu có lỗi trong quá trình lưu, trả lại lỗi
                return StatusCode(500, "Lỗi khi lưu dữ liệu.");
            }

            // Trả về kết quả sau khi thêm người dùng mới
            return CreatedAtAction("GetUser", new { id = user.UserId }, user);
        }
        private long GetFormattedDateAsLong()
        {
            var now = DateTime.Now;
            var formattedDate = now.ToString("yyyyMMdd"); // Chuyển thành chuỗi "YYYYMMDD"
            return long.Parse(formattedDate);  // Chuyển chuỗi thành long
        }

        // DELETE: api/Users/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(long id)
        {
            var bookingdel1 = _context.Bookings.Where(b => b.UserId == id).ToList();

            // Duyệt qua từng booking và cập nhật BookingId của các rooms về 0
            foreach (var booking in bookingdel1)
            {
                var roomsToUpdate = _context.Rooms.Where(r => r.BookingId == booking.BookingId).ToList();

                foreach (var room in roomsToUpdate)
                {
                    room.BookingId = 0;  // Cập nhật BookingId của phòng về 0
                }
            }

            var bookingdel = _context.Bookings.Where(b => b.UserId == id);
            _context.Bookings.RemoveRange(bookingdel);
            await _context.SaveChangesAsync();

            var reviewdel = _context.Reviews.Where(r => r.UserId == id);
            _context.Reviews.RemoveRange(reviewdel);
            await _context.SaveChangesAsync();

            var homestayUpdate = _context.Homestays.Where(h => h.UserId == id);
            foreach (var homestay in homestayUpdate)
            {
                homestay.UserId = 0;
            }
            await _context.SaveChangesAsync();

            var userdel = _context.Users.Where(u => u.UserId == id);    
            _context.Users.RemoveRange(userdel);
            await _context.SaveChangesAsync();

            if(userdel == null)
            {
                return NotFound();
            }
            return NoContent();
        }

        private bool UserExists(long id)
        {
            return _context.Users.Any(e => e.UserId == id);
        }
    }
}

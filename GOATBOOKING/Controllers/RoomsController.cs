using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GOATBOOKING.Models;
using System.Runtime.InteropServices;

namespace GOATBOOKING.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RoomsController : ControllerBase
    {
        private readonly MasterContext _context;

        public RoomsController(MasterContext context)
        {
            _context = context;
        }

        // GET: api/Rooms
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Room>>> GetRooms()
        {
            return await _context.Rooms.ToListAsync();
        }

        // GET: api/Rooms/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Room>> GetRoom(long id)
        {
            var room = await _context.Rooms.FindAsync(id);

            if (room == null)
            {
                return NotFound();
            }

            return room;
        }
        [HttpGet("booking_id")]
        public async Task<ActionResult<IEnumerable<Room>>> GetRoomsByBookingId(long id)
        {
            var room = await _context.Rooms.Where(r => r.BookingId == id).ToListAsync();
            if(room == null)
            {
                return NoContent();
            }else
            {
                return room;
            }
        }
        //[HttpGet("getRoom_Homestay")]
        //public async Task<ActionResult<IEnumerable<Room>>> GetRoom_R([FromQuery] int id)

        //[HttpGet("totalRoom")]
        //public async Task<ActionResult<int>> GetTotalRooms()
        //{
        //    var totalRoom = await _context.Rooms.CountAsync();
        //    return Ok(totalRoom);
        //}

        //hiện các  phòng thuộc homestay- nếu phòng còn trống

        [HttpGet("displayRoom_Homestay")]
            public async Task<ActionResult<IEnumerable<Room>>> GetRoom_Homestay([FromQuery] int id)
            {
                var query = _context.Rooms.AsQueryable();

                query = query.Where(r => r.HomestayId == id && r.Status == 0);

                var rooms = await query.ToListAsync();

                if (rooms.Count == 0 || rooms == null)
                {
                    return NotFound("không còn");
                }
                else
                {
                    return Ok(rooms);
                }

            
            }
        
        [HttpGet("search")]

        public async Task<ActionResult<IEnumerable<Room>>> GetRooms([FromQuery] string search)
        {                                                                   // FromQuery được lấy từ Urk 
            var query = _context.Rooms.AsQueryable();
            // lấy cơ sở dữ liệu ra

            if (!string.IsNullOrWhiteSpace(search))
            {
                query = query.Where(h => h.RoomId.ToString().Contains(search)  ||
                                         h.RoomName.ToString().Contains(search) ||
                                         h.RoomType.ToString().Contains(search) ||
                                         h.Price.ToString().Contains(search) ||
                                         h.Status.ToString().Contains(search) ||
                                         h.CreatedAt.ToString().Contains(search) ||
                                         h.BookingId.ToString().Contains(search) ||
                                         h.UpdatedAt.ToString().Contains(search));
            }
            var rooms = await query.ToListAsync();

            if (rooms == null || rooms.Count == 0)
            {
                return NotFound();
            }
            else
            {
                return Ok(rooms);
            }
        }
        // PUT: api/Rooms/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRoom(long id, Room room)
        {
            if (id != room.RoomId)
            {
                return BadRequest();
            }

            _context.Entry(room).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RoomExists(id))
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

        

        // POST: api/Rooms
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Room>> PostRoom(Room room)
        {
            
            if (_context.Rooms.Any(u => u.RoomId == room.RoomId))
            {
                return Conflict("RoomId đã tồn tại.");
            }

            // Đảm bảo các thuộc tính khác đã được gán đúng
            // cũ
            room.CreatedAt = GetFormattedDateAsLong();
            room.UpdatedAt = room.CreatedAt;

            // Thêm vào cơ sở dữ liệu
            _context.Rooms.Add(room);

            try
            {
                await _context.SaveChangesAsync();  // Lưu vào DB
            }
            catch (DbUpdateException)
            {
                // Nếu có lỗi trong quá trình lưu, trả lại lỗi
                return StatusCode(500, "Lỗi khi lưu dữ liệu.");
            }
            return CreatedAtAction("GetRoom", new { id = room.RoomId }, room);
        }
        private long GetFormattedDateAsLong()
        {
            var now = DateTime.Now;
            var formattedDate = now.ToString("yyyyMMdd"); // Chuyển thành chuỗi "YYYYMMDD"
            return long.Parse(formattedDate);  // Chuyển chuỗi thành long
        }

        // DELETE: api/Rooms/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRoom(long id)
        {
           
            var Roomsdelete = _context.Rooms.Where(r => r.RoomId == id);
            _context.Rooms.RemoveRange(Roomsdelete);
            await _context.SaveChangesAsync();

            if(Roomsdelete == null)
            {
                return NotFound();
            }
            else
            {
                return Ok(Roomsdelete);
            }

        }

        private bool RoomExists(long id)
        {
            return _context.Rooms.Any(e => e.RoomId == id);
        }
    }
}
